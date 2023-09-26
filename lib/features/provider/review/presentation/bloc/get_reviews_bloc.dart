import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/features/provider/review/domain/use_cases/get_reviews_use_case.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/review_entity.dart';

part 'get_reviews_event.dart';
part 'get_reviews_state.dart';

class GetReviewsBloc extends Bloc<GetReviewsEvent, GetReviewsState> {
  final GetReviewUseCase getReviewUseCase;
  GetReviewsBloc({

    required this.getReviewUseCase
  }) : super(GetReviewsState()) {
    on<GetProviderReviewsEvent>((event, emit) async{
        if (event.refresh) {
          emit(
            state.copyWith(
              status: GetReviewStatus.loading,
              hasReachedMax: false,
              data: [],
              errorMessage: '',
              pageNumber: 1,
           total: 0
            ),
          );
          final data = await getReviewUseCase(
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
                        status: GetReviewStatus.success,
                        hasReachedMax: true,
                      ),
                    )
                  : emit(
                      state.copyWith(
                        status: GetReviewStatus.success,
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

        if (state.status == GetReviewStatus.loading) {
          final data = await getReviewUseCase(page: state.pageNumber);
          await data.fold(
            (failure) {
              _mapFailureToState(failure, emit);
              return;
            },
            (data) {
              data.value2.isEmpty
                  ? emit(
                      state.copyWith(
                        status: GetReviewStatus.success,
                        hasReachedMax: true,
                      ),
                    )
                  : emit(
                      state.copyWith(
                        status: GetReviewStatus.success,
                        data: data.value2,
                        pageNumber: state.pageNumber + 1,
                        hasReachedMax: false,
                         total: data.value1
                      ),
                    );
            },
          );
        } else {
          emit(state.copyWith(status:GetReviewStatus.loadingMore ));
          final data = await getReviewUseCase(page: state.pageNumber);
          data.fold((failure) {
            _mapFailureToState(failure, emit);
          }, (data) {
            data.value2.isEmpty
                ? emit(state.copyWith(hasReachedMax: true))
                : emit(state.copyWith(
                    status: GetReviewStatus.success,
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
        emit(state.copyWith(status: GetReviewStatus.offline));
        return;

      case NetworkErrorFailure:
        emit(
          state.copyWith(
            status: GetReviewStatus.error,
            errorMessage: (f as NetworkErrorFailure).message,
          ),
        );
        return;
    }
  }
}
