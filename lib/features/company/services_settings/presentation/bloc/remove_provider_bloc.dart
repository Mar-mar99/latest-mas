import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/use_cases/remove_provider_use_case.dart';

part 'remove_provider_event.dart';
part 'remove_provider_state.dart';

class RemoveProviderBloc
    extends Bloc<RemoveProviderEvent, RemoveProviderState> {
  final RemoveProviderUseCase removeProviderUseCase;
  RemoveProviderBloc({required this.removeProviderUseCase})
      : super(RemoveProviderInitial()) {
    on<RemoveProviderFromServiceEvent>((event, emit) async {
      emit(LoadingRemoveProvider());

      final res1 = await removeProviderUseCase.call(
        providerId: event.providerId,
        serviceId: event.serviceId,
      );
      await res1.fold((f) {
        _mapFailureToState(emit, f);
      }, (attributes) async {
        emit(LoadedRemoveProvider());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(RemoveProviderOfflineState());
        break;

      case NetworkErrorFailure:
        emit(RemoveProviderNetworkErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const RemoveProviderNetworkErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
