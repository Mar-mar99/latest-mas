// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_password_bloc.dart';

abstract class EditPasswordEvent extends Equatable {
  const EditPasswordEvent();

  @override
  List<Object> get props => [];
}
class CurrentPasswordChangedEvent extends EditPasswordEvent {
  final String password;
  CurrentPasswordChangedEvent({
    required this.password,
  });
}
class NewPasswordChangedEvent extends EditPasswordEvent {
final String password;
  NewPasswordChangedEvent({
    required this.password,
  });
}

class ConfirmPasswordChangedEvent extends EditPasswordEvent {
  final String password;
  ConfirmPasswordChangedEvent({
    required this.password,
  });
}

class SubmitEditPasswordEvent extends EditPasswordEvent {
  final TypeAuth typeAuth;
  SubmitEditPasswordEvent({
    required this.typeAuth,
  });
}
