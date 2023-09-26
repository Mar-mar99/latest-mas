part of 'cancel_user_request_bloc.dart';

abstract class CancelUserRequestEvent extends Equatable {
  const CancelUserRequestEvent();

  @override
  List<Object> get props => [];
}

class CancelUserRequest extends CancelUserRequestEvent {
  final int id;
  final String reason;
  CancelUserRequest({
    required this.id,
    required this.reason,
  });
}
