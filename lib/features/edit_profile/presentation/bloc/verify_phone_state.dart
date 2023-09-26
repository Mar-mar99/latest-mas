part of 'verify_phone_bloc.dart';

abstract class VerifyPhoneState extends Equatable {
  const VerifyPhoneState();

  @override
  List<Object> get props => [];
}

class VerifyPhoneInitial extends VerifyPhoneState {}

class LoadingVerifyPhoneState extends VerifyPhoneState {}

class DoneVerifyPhoneState extends VerifyPhoneState {}

class VerifyPhoneOfflineState extends VerifyPhoneState {}

class VerifyPhoneErrorState extends VerifyPhoneState {
  final String message;
  VerifyPhoneErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
