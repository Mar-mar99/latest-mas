import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/features/user_emirate/data/models/uae_state_model.dart';
import 'package:masbar/features/user_emirate/domain/entities/uae_state_entity.dart';
import 'package:masbar/features/user_emirate/domain/use%20cases/fetch_uae_states_usecase.dart';

part 'uae_states_event.dart';
part 'uae_states_state.dart';

class UaeStatesBloc extends Bloc<UaeStatesEvent, UaeStatesState> {
  final FetchUaeStatesUseCase fetchUaeStatesUseCase;
  UaeStatesBloc({required this.fetchUaeStatesUseCase})
      : super(LoadingUaeStates()) {
    on<FetchUaeStatesEvent>((event, emit) async {
      emit(LoadingUaeStates());
      final res = await fetchUaeStatesUseCase();
      res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (states) => emit(
                LoadedUaeStates(states: states),
              ));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(UAEStatesOfflineState());
        break;

      case NetworkErrorFailure:
        emit(UAEStatesErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const UAEStatesErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
