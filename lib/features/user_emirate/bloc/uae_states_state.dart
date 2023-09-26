// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'uae_states_bloc.dart';

abstract class UaeStatesState extends Equatable {
  const UaeStatesState();

  @override
  List<Object> get props => [];
}


class LoadingUaeStates extends UaeStatesState{}
class LoadedUaeStates extends UaeStatesState {
  final List<UAEStateEntity> states;
  LoadedUaeStates({
    required this.states,
  });
  @override

  List<Object> get props => [states];
}


class UAEStatesOfflineState extends UaeStatesState{}

class UAEStatesErrorState extends UaeStatesState {
  final String message;
  const UAEStatesErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

