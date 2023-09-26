part of 'arrived_bloc.dart';

abstract class ArrivedState extends Equatable {
  const ArrivedState();

  @override
  List<Object> get props => [];
}

class ArrivedInitial extends ArrivedState {}

class LoadingArrived extends ArrivedState{
}
class DoneArrived extends ArrivedState{}


class ArrivedOfflineState extends ArrivedState {}

class ArrivedErrorState extends ArrivedState {
  final String message;
  const ArrivedErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
