import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/entities/expert_activity_entity.dart';
import '../../../domain/use_cases/get_experts_activity_use_case.dart';

part 'get_user_activity_event.dart';
part 'get_user_activity_state.dart';

class GetUserActivityBloc
    extends Bloc<GetUserActivityEvent, GetUserActivityState> {
  final GetExpertsActivityUseCase getExpertsActivityUseCase;
  GetUserActivityBloc({required this.getExpertsActivityUseCase})
      : super(GetUserActivityState.empty()) {
    on<GetProvidersActivityEvent>(
      (event, emit) async {
        if (event.refresh) {
          emit(
            state.copyWith(
              status: GetUserActivityStatus.loading,
              hasReachedMax: false,
              data: [],
              errorMessage: '',
              pageNumber: 1,
              total: 0
            ),
          );
          final data = await getExpertsActivityUseCase(
            page: 1,
          );

          await data.fold(
            (failure) {
              _mapFailureToState(failure, emit);
              return;
            },
            (data) {
              data.value2 .isEmpty
                  ? emit(
                      state.copyWith(
                        status: GetUserActivityStatus.success,
                        hasReachedMax: true,

                      ),
                    )
                  : emit(
                      state.copyWith(
                        status: GetUserActivityStatus.success,
                        data: data.value2,
                        pageNumber: state.pageNumber + 1,
                        hasReachedMax: false,
                        total: data.value1
                      ),
                    );
            },
          );
        }

        if (state.hasReachedMax) return;

        if (state.status == GetUserActivityStatus.loading) {
          final data = await getExpertsActivityUseCase(page: state.pageNumber);
          await data.fold(
            (failure) {
              _mapFailureToState(failure, emit);
              return;
            },
            (data) {
              data.value2.isEmpty
                  ? emit(
                      state.copyWith(
                        status: GetUserActivityStatus.success,
                        hasReachedMax: true,
                      ),
                    )
                  : emit(
                      state.copyWith(
                        status: GetUserActivityStatus.success,
                        data: data.value2,
                        pageNumber: state.pageNumber + 1,
                        hasReachedMax: false,
                        total: data.value1
                      ),
                    );
            },
          );
        } else {
          final data = await getExpertsActivityUseCase(page: state.pageNumber);
          data.fold((failure) {
            _mapFailureToState(failure, emit);
          }, (data) {
            data.value2.isEmpty
                ? emit(state.copyWith(hasReachedMax: true))
                : emit(state.copyWith(
                    status: GetUserActivityStatus.success,
                    data: List.of(state.data)..addAll(data.value2),
                    pageNumber: state.pageNumber + 1,
                    hasReachedMax: false,
                    total: data.value1));
          });
        }
      },
      transformer: droppable(),
    );
  }
  _mapFailureToState(Failure f, Emitter emit) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(state.copyWith(status: GetUserActivityStatus.offline));
        return;

      case NetworkErrorFailure:
        emit(
          state.copyWith(
            status: GetUserActivityStatus.error,
            errorMessage: (f as NetworkErrorFailure).message,
          ),
        );
        return;
    }
  }
}
