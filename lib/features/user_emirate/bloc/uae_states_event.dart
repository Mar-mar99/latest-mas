part of 'uae_states_bloc.dart';

abstract class UaeStatesEvent extends Equatable {
  const UaeStatesEvent();

  @override
  List<Object> get props => [];
}

class FetchUaeStatesEvent extends UaeStatesEvent{}
