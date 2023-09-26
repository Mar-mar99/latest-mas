import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/use_cases/request_offline_provider_use_case.dart';

part 'reschedule_request_event.dart';
part 'reschedule_request_state.dart';

class RescheduleRequestBloc
    extends Bloc<RescheduleRequestEvent, RescheduleRequestState> {
  final RequestOfflineProviderUseCase requestOfflineProviderUseCase;
  RescheduleRequestBloc({required this.requestOfflineProviderUseCase})
      : super(RescheduleRequestInitial()) {
    on<RescheduleEvent>((event, emit) async {
      emit(LoadingRescheduleRequest());

      final res = await requestOfflineProviderUseCase.call(
          providerId: event.providerId,
          requestId: event.requestId,
          scheduleDate: event.scheduleDate,
          scheduleTime: event.scheduleTime);
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (data) {
          emit(LoadedRescheduleRequest());
        },
      );
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(RescheduleRequestOfflineState());
        break;

      case NetworkErrorFailure:
        emit(RescheduleRequestErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const RescheduleRequestErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
