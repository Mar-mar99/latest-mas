// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'loggin_bloc.dart';

abstract class LogginEvent extends Equatable {
  const LogginEvent();

  @override
  List<Object> get props => [];
}

class EmailLogginChangedEvent extends LogginEvent {
  final String email;
  const EmailLogginChangedEvent({
    required this.email,
  });
  @override
  List<Object> get props => [email];
}

class PasswordLogginChangedEvent extends LogginEvent {
  final String password;
  const PasswordLogginChangedEvent({
    required this.password,
  });
  @override
  List<Object> get props => [password];
}

class SubmitLogginEvent extends LogginEvent {
  final LoginUserType loginUserType;
  SubmitLogginEvent({
    required this.loginUserType,
  });
  @override
  List<Object> get props => [loginUserType];
}
