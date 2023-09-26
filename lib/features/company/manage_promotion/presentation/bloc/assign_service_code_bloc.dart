// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/use_cases/assign_service_use_case.dart';

part 'assign_service_code_event.dart';
part 'assign_service_code_state.dart';

class AssignServiceCodeBloc extends Bloc<AssignServiceCodeEvent, AssignServiceCodeState> {
 final AssignServiceUseCase assignServiceUseCase;
  AssignServiceCodeBloc({
   required this.assignServiceUseCase,
  }
  ) : super(AssignServiceCodeInitial()) {
    on<AssignServiceToPromo>((event, emit) async{
    emit(LoadingAssignService());
      final res = await assignServiceUseCase.call(promoId: event.promoId, serviceId: event.serviceId);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedAssignService(serviveId: event.serviceId));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(AssignServiceOfflineState());
        break;

      case NetworkErrorFailure:
        emit(AssignServiceErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(AssignServiceErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
