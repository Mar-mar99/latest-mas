// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'submit_new_password_bloc.dart';

abstract class SubmitNewPasswordEvent extends Equatable {
  const SubmitNewPasswordEvent();

  @override
  List<Object> get props => [];
}

class SubmitDataEvent extends SubmitNewPasswordEvent {
  final int id;
  final String code;
  final String password;
  final String confirmPassword;
  final TypeAuth typeAuth;
  SubmitDataEvent(this.typeAuth, {
    required this.id,
    required this.code,
    required this.password,
    required this.confirmPassword,
  });
  @override
  List<Object> get props => [
        [id, code, password, confirmPassword,typeAuth]
      ];
}
