part of 'log_out_bloc.dart';

abstract class LogOutState extends Equatable {
  const LogOutState();

  @override
  List<Object> get props => [];
}

class LogOutInitial extends LogOutState {}

class LoadingLogOut extends LogOutState{
}
class DoneLogOut extends LogOutState{}


class LogOutOfflineState extends LogOutState {}

class LogOutErrorState extends LogOutState {
  final String message;
  const LogOutErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
