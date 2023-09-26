// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/use_cases/remove_service_use_case.dart';

part 'remove_service_code_event.dart';
part 'remove_service_code_state.dart';

class RemoveServiceCodeBloc extends Bloc<RemoveServiceCodeEvent, RemoveServiceCodeState> {
  final RemoveServiceUseCase removeServiceUseCase;
  RemoveServiceCodeBloc({
   required this.removeServiceUseCase,
  }
  ) : super(RemoveServiceCodeInitial()) {
    on<RemoveServicePromo>((event, emit)async {
     emit(LoadingRemoveServiceCode());
      final res = await removeServiceUseCase.call(promoId: event.promoId, serviceId: event.serviceId);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedRemoveServiceCode(serviveId: event.serviceId));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(RemoveServiceCodeOfflineState());
        break;

      case NetworkErrorFailure:
        emit(RemoveServiceCodeErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(RemoveServiceCodeErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
