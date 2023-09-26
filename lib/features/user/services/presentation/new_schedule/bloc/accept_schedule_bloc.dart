// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/use_cases/accept_provider_schdule_use_case.dart';

part 'accept_schedule_event.dart';
part 'accept_schedule_state.dart';

class AcceptScheduleBloc extends Bloc<AcceptScheduleEvent, AcceptScheduleState> {
 final AcceptProviderScheduleUseCase acceptProviderScheduleUseCase;
  AcceptScheduleBloc({
   required this.acceptProviderScheduleUseCase,
  }
  ) : super(AcceptScheduleInitial()) {
    on<AcceptEvent>((event, emit)async {
      emit(LoadingAcceptSchedule());

      final res = await acceptProviderScheduleUseCase.call(
          providerId: event.providerId,requestId: event.requestId);
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (data) {
          emit(LoadedAcceptSchedule());
        },
      );
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(AcceptScheduleOfflineState());
        break;

      case NetworkErrorFailure:
        emit(AcceptScheduleErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const AcceptScheduleErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}


