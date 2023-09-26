part of 'submit_new_password_bloc.dart';

abstract class SubmitNewPasswordState extends Equatable {
  const SubmitNewPasswordState();

  @override
  List<Object> get props => [];
}

class SubmitNewPasswordInitial extends SubmitNewPasswordState {}

class LoadingSubmitNewPasswordState extends SubmitNewPasswordState {}

class DoneSubmitNewPasswordState extends SubmitNewPasswordState {}

class SubmitNewPasswordStateOfflineState extends SubmitNewPasswordState {}

class SubmitNewPasswordStateErrorState extends SubmitNewPasswordState {
  final String message;
  const SubmitNewPasswordStateErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
