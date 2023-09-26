part of 'cancel_after_accept_bloc.dart';

abstract class CancelAfterAcceptState extends Equatable {
  const CancelAfterAcceptState();

  @override
  List<Object> get props => [];
}

class CancelInitial extends CancelAfterAcceptState {}

class LoadingCancel extends CancelAfterAcceptState{
}
class DoneCancel extends CancelAfterAcceptState{}


class CancelOfflineState extends CancelAfterAcceptState {}

class CancelErrorState extends CancelAfterAcceptState {
  final String message;
  const CancelErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
