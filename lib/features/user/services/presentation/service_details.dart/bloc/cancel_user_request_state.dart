part of 'cancel_user_request_bloc.dart';

abstract class CancelUserRequestState extends Equatable {
  const CancelUserRequestState();

  @override
  List<Object> get props => [];
}

class CancelUserRequestInitial extends CancelUserRequestState {}

class LoadingCancelUserRequest extends CancelUserRequestState{
}
class DoneCancelUserRequest extends CancelUserRequestState{}


class CancelUserRequestOfflineState extends CancelUserRequestState {}

class CancelUserRequestErrorState extends CancelUserRequestState {
  final String message;
  const CancelUserRequestErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
