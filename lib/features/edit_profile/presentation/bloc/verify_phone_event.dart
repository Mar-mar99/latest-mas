// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'verify_phone_bloc.dart';

abstract class VerifyPhoneEvent extends Equatable {
  const VerifyPhoneEvent();

  @override
  List<Object> get props => [];
}
class VerifyEvent extends VerifyPhoneEvent {
  final TypeAuth typeAuth;
  final String number;
  final String otpCode;
  VerifyEvent({
    required this.typeAuth,
    required this.number,
    required this.otpCode,
  });
}
