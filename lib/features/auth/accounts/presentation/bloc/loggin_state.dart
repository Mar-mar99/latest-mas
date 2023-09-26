// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'loggin_bloc.dart';

class LogginState extends Equatable {
  final String email;
  final String password;
  final FormSubmissionState formSubmissionState;
  const LogginState({
    required this.email,
    required this.password,
    required this.formSubmissionState,
  });

  @override
  List<Object> get props => [email, password, formSubmissionState];

  factory LogginState.empty() {
    return const LogginState(
      email: '',
      password: '',
      formSubmissionState: InitialFormState(),
    );
  }

  LogginState copyWith(
      {String? email,
      String? password,
      FormSubmissionState? formSubmissionState}) {
    return LogginState(
      email: email ?? this.email,
      password: password ?? this.password,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
    );
  }
}
