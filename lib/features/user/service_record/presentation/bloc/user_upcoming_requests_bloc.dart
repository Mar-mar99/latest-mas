import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/upcoming_request_user_entity.dart';
import '../../domain/use_cases/get_user_upcoming_records_use_case.dart';

part 'user_upcoming_requests_event.dart';
part 'user_upcoming_requests_state.dart';

class UserUpcomingRequestsBloc extends Bloc<UserUpcomingRequestsEvent, UserUpcomingRequestsState> {
 final GetUserUpcomingRecordsUseCase getUserUpcomingRecordsUseCase;

  UserUpcomingRequestsBloc({
    required this.getUserUpcomingRecordsUseCase
  }) : super(UserUpcomingRequestsState()) {
    on<GetUserUpcomingtRequestsEvent>((event, emit)  async {

    if (event.refresh) {
          emit(
            state.copyWith(
              status: UserUpcomingRequestsStatus.loading,
              hasReachedMax: false,
              data: [],
              errorMessage: '',
              pageNumber: 1,
            ),
          );
          final data = await getUserUpcomingRecordsUseCase(
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
                        status: UserUpcomingRequestsStatus.success,
                        hasReachedMax: true,

                      ),
                    )
                  : emit(
                      state.copyWith(
                        status: UserUpcomingRequestsStatus.success,
                        data: data,
                        pageNumber: state.pageNumber + 1,
                        hasReachedMax: false,
                      ),
                    );
            },
          );
        }


        if (state.hasReachedMax) return;

        if (state.status == UserUpcomingRequestsStatus.loading) {
          final data =
              await getUserUpcomingRecordsUseCase(page: state.pageNumber);
          await data.fold(
            (failure) {
              _mapFailureToState(failure, emit);
              return;
            },
            (data) {
              data.isEmpty
                  ? emit(
                      state.copyWith(
                        status: UserUpcomingRequestsStatus.success,
                        hasReachedMax: true,
                      ),
                    )
                  : emit(
                      state.copyWith(
                        status: UserUpcomingRequestsStatus.success,
                        data: data,
                        pageNumber: state.pageNumber + 1,
                        hasReachedMax: false,
                      ),
                    );
            },
          );
        } else {
          emit(state.copyWith(status: UserUpcomingRequestsStatus.loadingMore));
          final data =
              await getUserUpcomingRecordsUseCase(page: state.pageNumber);
          data.fold((failure) {
            _mapFailureToState(failure, emit);
          }, (data) {
            data.isEmpty
                ? emit(state.copyWith(hasReachedMax: true))
                : emit(state.copyWith(
                    status: UserUpcomingRequestsStatus.success,
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
        emit(state.copyWith(status: UserUpcomingRequestsStatus.offline));
        return;

      case NetworkErrorFailure:
        emit(
          state.copyWith(
            status: UserUpcomingRequestsStatus.error,
            errorMessage: (f as NetworkErrorFailure).message,
          ),
        );
        return;
    }
  }
}
