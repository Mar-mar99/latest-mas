import 'package:equatable/equatable.dart';

abstract class FormSubmissionState extends Equatable {

 const FormSubmissionState();
  @override
  List<Object> get props => [];
}

class InitialFormState extends FormSubmissionState {
  const InitialFormState();
}

class FormSubmittingState extends FormSubmissionState {}

class FormSuccesfulState extends FormSubmissionState {}

class FormNoInternetState extends FormSubmissionState {}

class FormNetworkErrorState extends FormSubmissionState {
  final String message;
  const FormNetworkErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
