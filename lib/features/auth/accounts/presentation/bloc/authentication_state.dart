part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticatationLoading extends AuthenticationState {}

//show login screen
class UnauthenticatedState extends AuthenticationState {}

//show otp state verified=0
class VerificataionState extends AuthenticationState{}

//show otp state verified=0
class OnBoardingState extends AuthenticationState{}

//show homepage verified =1
class AuthenticatedState extends AuthenticationState {
}

