part of 'send_email_forget_password_bloc.dart';

abstract class SendEmailForgetPasswordState extends Equatable {
  const SendEmailForgetPasswordState();

  @override
  List<Object> get props => [];
}

class SendEmailForgetPasswordInitial extends SendEmailForgetPasswordState {}
class LoadingSendEmailForgetPassword extends SendEmailForgetPasswordState{}
class DoneSendEmailForgetPassword extends SendEmailForgetPasswordState {
  final int id;
  DoneSendEmailForgetPassword({
    required this.id,
  });
  @override

  List<Object> get props => [id];
}
class SendEmailForgetPasswordOfflineState extends SendEmailForgetPasswordState{}
class SendEmailForgetPasswordErrorState extends SendEmailForgetPasswordState {
  final String message;
  const SendEmailForgetPasswordErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
