// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'verify_account_bloc.dart';

abstract class VerifyAccountState extends Equatable {
  const VerifyAccountState();

  @override
  List<Object> get props => [];
}

class VerifyAccountInitial extends VerifyAccountState {}
class VerifyAccountLoading extends VerifyAccountState {}
class DoneVerifyAccount extends VerifyAccountState {}
class DoneResendCode extends VerifyAccountState {}
class VerifyAccountOffline extends VerifyAccountState {}
class VerifyAccountNetworkError extends VerifyAccountState {
  final String message;
  VerifyAccountNetworkError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
