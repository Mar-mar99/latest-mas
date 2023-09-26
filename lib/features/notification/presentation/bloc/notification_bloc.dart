import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/use_case/get_notification_use_case.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationUseCase getNotificationUseCase;
  NotificationBloc({required this.getNotificationUseCase})
      : super(const NotificationState()) {
    on<LoadNotificationEvent>(
      (event, emit) async {
        if (event.refresh) {
          emit(
            state.copyWith(
              status: NotificationStatus.loading,
              hasReachedMax: false,
              data: [],
              errorMessage: '',
              pageNumber: 1,
            ),
          );
          final data = await getNotificationUseCase(
            page: 1,
            typeAuth: event.typeAuth,
          );

          await data.fold(
            (failure) {
              _mapFailureToState(
                emit,
                failure,
              );
              return;
            },
            (data) {
              data.isEmpty
                  ? emit(
                      state.copyWith(
                        status: NotificationStatus.success,
                        hasReachedMax: true,
                      ),
                    )
                  : emit(
                      state.copyWith(
                        status: NotificationStatus.success,
                        data: data,
                        pageNumber: state.pageNumber + 1,
                        hasReachedMax: false,
                      ),
                    );
            },
          );
        }
        if (state.hasReachedMax) return;

        if (state.status == NotificationStatus.loading) {
          final data = await getNotificationUseCase(
            page: state.pageNumber,
            typeAuth: event.typeAuth,
          );

          await data.fold(
            (failure) {
              _mapFailureToState(
                emit,
                failure,
              );
              return;
            },
            (data) {
              data.isEmpty
                  ? emit(
                      state.copyWith(
                        status: NotificationStatus.success,
                        hasReachedMax: true,
                      ),
                    )
                  : emit(
                      state.copyWith(
                        status: NotificationStatus.success,
                        data: data,
                        pageNumber: state.pageNumber + 1,
                        hasReachedMax: false,
                      ),
                    );
            },
          );
        } else {
          emit(state.copyWith(status: NotificationStatus.loadingMore));
          final data = await getNotificationUseCase(
            page: state.pageNumber,
            typeAuth: event.typeAuth,
          );
          data.fold((failure) {
            _mapFailureToState(emit, failure);
          }, (data) {
            data.isEmpty
                ? emit(state.copyWith(hasReachedMax: true))
                : emit(state.copyWith(
                    status: NotificationStatus.success,
                    data: List.of(state.data)..addAll(data),
                    pageNumber: state.pageNumber + 1,
                    hasReachedMax: false));
          });
        }
      },
      transformer: droppable(),
    );
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(state.copyWith(status: NotificationStatus.offline));
        break;

      case NetworkErrorFailure:
        emit(state.copyWith(
            status: NotificationStatus.error,
            errorMessage: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(state.copyWith(
            status: NotificationStatus.error, errorMessage: ('error')));
        break;
    }
  }
}
