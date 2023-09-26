// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_signup_bloc.dart';

abstract class UserSignupEvent extends Equatable {
  const UserSignupEvent();

  @override
  List<Object> get props => [];
}

class FirstNameChangedEvent extends UserSignupEvent {
  final String firstName;
  const FirstNameChangedEvent({
    required this.firstName,
  });
  @override
  List<Object> get props => [firstName];
}

class LastNameChangedEvent extends UserSignupEvent {
  final String lastName;
  const LastNameChangedEvent({
    required this.lastName,
  });
  @override
  List<Object> get props => [lastName];
}

class EmailChangedEvent extends UserSignupEvent {
  final String email;
  const EmailChangedEvent({
    required this.email,
  });
  @override
  List<Object> get props => [email];
}

class PhoneChangedEvent extends UserSignupEvent {
  final String phone;
  const PhoneChangedEvent({
    required this.phone,
  });
  @override
  List<Object> get props => [phone];
}
class StateChangedEvent extends UserSignupEvent {
  final int state;
  const StateChangedEvent({
    required this.state,
  });
  @override
  List<Object> get props => [state];
}

class PasswordChangedEvent extends UserSignupEvent {
  final String password;
  const PasswordChangedEvent({
    required this.password,
  });
  @override
  List<Object> get props => [password];
}

class ConfirmPasswordChangedEvent extends UserSignupEvent {
  final String confirmPassword;
  const ConfirmPasswordChangedEvent({
    required this.confirmPassword,
  });
  @override
  List<Object> get props => [confirmPassword];
}



class SubmitEvent extends UserSignupEvent{}
