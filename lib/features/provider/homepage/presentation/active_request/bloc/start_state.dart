part of 'start_bloc.dart';

abstract class StartState extends Equatable {
  const StartState();

  @override
  List<Object> get props => [];
}

class StartInitial extends StartState {}

class LoadingStart extends StartState{
}
class DoneStart extends StartState{}


class StartOfflineState extends StartState {}

class StartErrorState extends StartState {
  final String message;
  const StartErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
