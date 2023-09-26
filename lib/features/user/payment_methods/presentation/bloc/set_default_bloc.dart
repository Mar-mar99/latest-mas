import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/use_cases/set_default_use_case.dart';

part 'set_default_event.dart';
part 'set_default_state.dart';

class SetDefaultBloc extends Bloc<SetDefaultEvent, SetDefaultState> {
final SetDefaultUseCase setDefaultUseCase;

  SetDefaultBloc({
    required this.setDefaultUseCase
  }) : super(SetDefaultInitial()) {
    on<SetDefaultCardEvent>((event, emit) async{
      emit(LoadingSetDefault());
      final res = await setDefaultUseCase(cardId: event.id);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(DoneSetDefault());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(SetDefaultOfflineState());
        break;

      case NetworkErrorFailure:
        emit(
            SetDefaultErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(
            SetDefaultErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
