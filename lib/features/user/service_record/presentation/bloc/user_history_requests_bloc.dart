import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/history_request_user_entity.dart';
import '../../domain/use_cases/get_user_history_records_use_case.dart';

part 'user_history_requests_event.dart';
part 'user_history_requests_state.dart';

class UserHistoryRequestsBloc
    extends Bloc<UserHistoryRequestsEvent, UserHistoryRequestsState> {
  final GetUserHistoryRecordsUseCase getUserHistoryRecordsUseCase;
  UserHistoryRequestsBloc({
    required this.getUserHistoryRecordsUseCase,
  }) : super(const UserHistoryRequestsState()) {

    on<GetUserPastRequestsEvent>(
      (event, emit) async {
    if (event.refresh) {
      //refrshing
          emit(
            state.copyWith(
              status: UserPastRequestsStatus.loading,
              hasReachedMax: false,
              data: [],
              errorMessage: '',
              pageNumber: 1,
            ),
          );
          final data = await getUserHistoryRecordsUseCase(
            page: 1,

          );

          await data.fold(
            (failure) {
              _mapFailureToState(failure, emit);
              return;
            },
            (data) {
              data.isEmpty
                  ? emit(
                      state.copyWith(
                        status: UserPastRequestsStatus.success,
                        hasReachedMax: true,

                      ),
                    )
                  : emit(
                      state.copyWith(
                        status: UserPastRequestsStatus.success,
                        data: data,
                        pageNumber: state.pageNumber + 1,
                        hasReachedMax: false,
                      ),
                    );
            },
          );
        }



        if (state.hasReachedMax) return;

        if (state.status == UserPastRequestsStatus.loading) {
          //first time
          final data =
              await getUserHistoryRecordsUseCase(page: state.pageNumber);
          await data.fold(
            (failure) {
              _mapFailureToState(failure, emit);
              return;
            },
            (data) {
              data.isEmpty
                  ? emit(
                      state.copyWith(
                        status: UserPastRequestsStatus.success,
                        hasReachedMax: true,
                      ),
                    )
                  : emit(
                      state.copyWith(
                        status: UserPastRequestsStatus.success,
                        data: data,
                        pageNumber: state.pageNumber + 1,
                        hasReachedMax: false,
                      ),
                    );
            },
          );
        } else {
          emit(state.copyWith(status:UserPastRequestsStatus.loadingMore ));
          final data =
              await getUserHistoryRecordsUseCase(page: state.pageNumber);
          data.fold((failure) {
            _mapFailureToState(failure, emit);
          }, (data) {
            data.isEmpty
                ? emit(state.copyWith(hasReachedMax: true))
                : emit(state.copyWith(
                    status: UserPastRequestsStatus.success,
                    data: List.of(state.data)..addAll(data),
                    pageNumber: state.pageNumber + 1,
                    hasReachedMax: false));
          });
        }
      },
      transformer: droppable(),
    );
  }
  _mapFailureToState(Failure f, Emitter emit) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(state.copyWith(status: UserPastRequestsStatus.offline));
        return;

      case NetworkErrorFailure:
        emit(
          state.copyWith(
            status: UserPastRequestsStatus.error,
            errorMessage: (f as NetworkErrorFailure).message,
          ),
        );
        return;
    }
  }
}
