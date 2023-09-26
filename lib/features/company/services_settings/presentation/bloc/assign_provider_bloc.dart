// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/use_cases/assign_provider_use_case.dart';

part 'assign_provider_event.dart';
part 'assign_provider_state.dart';

class AssignProviderBloc
    extends Bloc<AssignProviderEvent, AssignProviderState> {
  final AssignProviderUseCase assignProviderUseCase;
  AssignProviderBloc({
    required this.assignProviderUseCase,
  }) : super(AssignProviderInitial()) {
    on<AssignProviderToServiceEvent>((event, emit) async {
      emit(LoadingAssignProvider());
      final res1 = await assignProviderUseCase.call(
        providerId: event.providerId,
        serviceId: event.serviceId,
      );
      await res1.fold((f) {
        _mapFailureToState(emit, f);
      }, (attributes) async {
        emit(LoadedAssignProvider());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(AssignProviderOfflineState());
        break;

      case NetworkErrorFailure:
        emit(AssignProviderNetworkErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(AssignProviderNetworkErrorState(message: 'Error'));
        break;
    }
  }
}
