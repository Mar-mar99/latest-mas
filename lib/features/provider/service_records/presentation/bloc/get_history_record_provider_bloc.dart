import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/request_past_provider_entity.dart';
import '../../domain/use_cases/get_provider_history_use_case.dart';

part 'get_history_record_provider_event.dart';
part 'get_history_record_provider_state.dart';

class GetHistoryRecordProviderBloc
    extends Bloc<GetHistoryRecordProviderEvent, GetHistoryRecordProviderState> {
  final GetProviderHistoryUseCase getProviderHistoryUseCase;

  GetHistoryRecordProviderBloc({required this.getProviderHistoryUseCase})
      : super(GetHistoryRecordProviderState()) {
    on<GetProviderPastRequestsEvent>(
      (event, emit) async {
        if (event.refresh) {
          emit(
            state.copyWith(
              status: ProviderPastRequestsStatus.loading,
              hasReachedMax: false,
              data: [],
              errorMessage: '',
              pageNumber: 1,
            ),
          );
          final data = await getProviderHistoryUseCase(
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
                        status: ProviderPastRequestsStatus.success,
                        hasReachedMax: true,
                      ),
                    )
                  : emit(
                      state.copyWith(
                        status: ProviderPastRequestsStatus.success,
                        data: data,
                        pageNumber: state.pageNumber + 1,
                        hasReachedMax: false,
                      ),
                    );
            },
          );
        }

        if (state.hasReachedMax) return;

        if (state.status == ProviderPastRequestsStatus.loading) {
          final data = await getProviderHistoryUseCase(page: state.pageNumber);
          await data.fold(
            (failure) {
              _mapFailureToState(failure, emit);
              return;
            },
            (data) {
              data.isEmpty
                  ? emit(
                      state.copyWith(
                        status: ProviderPastRequestsStatus.success,
                        hasReachedMax: true,
                      ),
                    )
                  : emit(
                      state.copyWith(
                        status: ProviderPastRequestsStatus.success,
                        data: data,
                        pageNumber: state.pageNumber + 1,
                        hasReachedMax: false,
                      ),
                    );
            },
          );
        } else {
          emit(state.copyWith(status:ProviderPastRequestsStatus.loadingMore ));
          final data = await getProviderHistoryUseCase(page: state.pageNumber);
          data.fold((failure) {
            _mapFailureToState(failure, emit);
          }, (data) {
            data.isEmpty
                ? emit(state.copyWith(hasReachedMax: true))
                : emit(state.copyWith(
                    status: ProviderPastRequestsStatus.success,
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
        emit(state.copyWith(status: ProviderPastRequestsStatus.offline));
        return;

      case NetworkErrorFailure:
        emit(
          state.copyWith(
            status: ProviderPastRequestsStatus.error,
            errorMessage: (f as NetworkErrorFailure).message,
          ),
        );
        return;
    }
  }
}
