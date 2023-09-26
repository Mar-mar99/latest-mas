import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/request_upcoming_provider_entity.dart';
import '../../domain/use_cases/get_provider_upcoming_use_case.dart';

part 'get_upcoming_record_provider_event.dart';
part 'get_upcoming_record_provider_state.dart';

class GetUpcomingRecordProviderBloc extends Bloc<GetUpcomingRecordProviderEvent, GetUpcomingRecordProviderState> {
  final GetProviderUpcomingUseCase getProviderUpcomingUseCase;
  GetUpcomingRecordProviderBloc({
    required this.getProviderUpcomingUseCase
  }) : super(GetUpcomingRecordProviderState()) {
    on<GetProviderUpcomingtRequestsEvent>((event, emit)async {
       if (event.refresh) {
          emit(
            state.copyWith(
              status: ProviderUpcomingRequestsStatus.loading,
              hasReachedMax: false,
              data: [],
              errorMessage: '',
              pageNumber: 1,
            ),
          );
          final data = await getProviderUpcomingUseCase(
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
                        status: ProviderUpcomingRequestsStatus.success,
                        hasReachedMax: true,

                      ),
                    )
                  : emit(
                      state.copyWith(
                        status: ProviderUpcomingRequestsStatus.success,
                        data: data,
                        pageNumber: state.pageNumber + 1,
                        hasReachedMax: false,
                      ),
                    );
            },
          );
        }


        if (state.hasReachedMax) return;

        if (state.status == ProviderUpcomingRequestsStatus.loading) {
          final data =
              await getProviderUpcomingUseCase(page: state.pageNumber);
          await data.fold(
            (failure) {
              _mapFailureToState(failure, emit);
              return;
            },
            (data) {
              data.isEmpty
                  ? emit(
                      state.copyWith(
                        status: ProviderUpcomingRequestsStatus.success,
                        hasReachedMax: true,
                      ),
                    )
                  : emit(
                      state.copyWith(
                        status: ProviderUpcomingRequestsStatus.success,
                        data: data,
                        pageNumber: state.pageNumber + 1,
                        hasReachedMax: false,
                      ),
                    );
            },
          );
        } else {
          emit(state.copyWith(status:ProviderUpcomingRequestsStatus.loadingMore ));
          final data =
              await getProviderUpcomingUseCase(page: state.pageNumber);
          data.fold((failure) {
            _mapFailureToState(failure, emit);
          }, (data) {
            data.isEmpty
                ? emit(state.copyWith(hasReachedMax: true))
                : emit(state.copyWith(
                    status: ProviderUpcomingRequestsStatus.success,
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
        emit(state.copyWith(status: ProviderUpcomingRequestsStatus.offline));
        return;

      case NetworkErrorFailure:
        emit(
          state.copyWith(
            status: ProviderUpcomingRequestsStatus.error,
            errorMessage: (f as NetworkErrorFailure).message,
          ),
        );
        return;
    }
  }
}
