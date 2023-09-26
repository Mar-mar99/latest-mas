// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'send_email_forget_password_bloc.dart';

abstract class SendEmailForgetPasswordEvent extends Equatable {
  const SendEmailForgetPasswordEvent();

  @override
  List<Object> get props => [];
}
class SendEmailEvent extends SendEmailForgetPasswordEvent {
  final String email;
  final TypeAuth typeAuth;
  SendEmailEvent({
    required this.email,
    required this.typeAuth,
  });

@override

  List<Object> get props => [email,typeAuth];
}
