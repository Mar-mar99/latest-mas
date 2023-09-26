// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:masbar/features/company/services_settings/domain/use_cases/set_cancellation_use_case.dart';

import '../../../../../core/errors/failures.dart';

part 'set_cancellation_event.dart';
part 'set_cancellation_state.dart';

class SetCancellationBloc extends Bloc<SetCancellationEvent, SetCancellationState> {
 final SetCancellationUseCase setCancellationUseCase;
  SetCancellationBloc({
   required this.setCancellationUseCase,
  }
  ) : super(SetCancellationInitial()) {
    on<SetCancellationSettings>((event, emit) async{
     emit(LoadingSetCancellation());

      final res1 =
          await setCancellationUseCase.call(serviceId: event.serviceId,fees: event.fees,hasCancellationFees: event.hasCancellationFees,);
      await res1.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) async {
        emit(LoadedSetCancellation());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(SetCancellationOfflineState());
        break;

      case NetworkErrorFailure:
        emit(SetCancellationNetworkErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const SetCancellationNetworkErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
