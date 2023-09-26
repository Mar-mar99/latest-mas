// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'verify_account_bloc.dart';

abstract class VerifyAccountEvent extends Equatable {
  const VerifyAccountEvent();

  @override
  List<Object> get props => [];
}
class SendCodeEvent extends VerifyAccountEvent {
  final String code;

  SendCodeEvent({
    required this.code,

  });
  @override
  List<Object> get props => [code,];

}
class ReSendCodeEvent extends VerifyAccountEvent {


}
