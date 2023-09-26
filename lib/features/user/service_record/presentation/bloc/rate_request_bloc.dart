import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/features/user/service_record/domain/use_cases/rate_request_use_case.dart';

import '../../../../../core/errors/failures.dart';

part 'rate_request_event.dart';
part 'rate_request_state.dart';

class RateRequestBloc extends Bloc<RateRequestEvent, RateRequestState> {
  final RateRequestUseCase rateRequestUseCase;
  RateRequestBloc({required this.rateRequestUseCase})
      : super(RateRequestInitial()) {
    on<RateEvent>((event, emit) async {
      emit(LoadingRateRequest());
      final res = await rateRequestUseCase.call(
        rating: event.rating,
        requestId: event.requestId,
        comment: event.comment,
        isFav: event.isFav
      );
      res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (data) => emit(
                LoadedRateRequest(),
              ));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(RateRequestOfflineState());
        break;

      case NetworkErrorFailure:
        emit(
            RateRequestErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const RateRequestErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
