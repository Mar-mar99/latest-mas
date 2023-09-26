// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/use_cases/enable_disable_use_case.dart';

part 'enable_disable_event.dart';
part 'enable_disable_state.dart';

class EnableDisableBloc extends Bloc<EnableDisableEvent, EnableDisableState> {
  final EnableDisableUseCase enableDisableUseCase;

  EnableDisableBloc({
    required this.enableDisableUseCase,
  }) : super(EnableDisableInitial()) {
    on<EnableEvent>((event, emit) async {
  emit(LoadingEnableDisableState());
      final res1 = await enableDisableUseCase.call(enable: true, id: event.id);
      await res1.fold((f) {
        _mapFailureToState(emit, f);
      }, (info) async {
      emit(DoneEnableDisableState());

      });
    });

    on<DisableEvent>((event, emit) async {

        emit(LoadingEnableDisableState());
      final res1 = await enableDisableUseCase.call(enable: false, id: event.id);
      await res1.fold((f) {
        _mapFailureToState(emit, f);
      }, (info) async {
emit(DoneEnableDisableState());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(EnableDisableOfflineState());
        break;

      case NetworkErrorFailure:
        emit(EnableDisableStateErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const EnableDisableStateErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
