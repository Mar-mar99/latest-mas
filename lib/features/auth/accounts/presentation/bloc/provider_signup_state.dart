// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'provider_signup_bloc.dart';
enum ProviderSignupValidation {
  init,

  lessThanTwoDocuments

}
class ProviderSignupState extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String code;
  final String password;
  final String confirmPassword;
  final List<File> documents;
  final FormSubmissionState formSubmissionState;
  final ProviderSignupValidation validation;
  ProviderSignupState(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      required this.code,
      required this.password,
      required this.confirmPassword,
      required this.documents,
      required this.formSubmissionState,
      required this.validation});
  factory ProviderSignupState.empty() {
    return ProviderSignupState(
      firstName: '',
      lastName: '',
      email: '',
      phone: '',
      code: '',
      password: '',
      confirmPassword: '',
      documents: const [],
      validation:ProviderSignupValidation.init,
      formSubmissionState: const InitialFormState(),
    );
  }

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        phone,
        code,
        password,
        confirmPassword,
        documents,
        formSubmissionState,
        validation
      ];

  ProviderSignupState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? code,
    String? password,
    String? confirmPassword,
    List<File>? documents,
    FormSubmissionState? formSubmissionState,
       ProviderSignupValidation? validation
  }) {
    return ProviderSignupState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      code: code ?? this.code,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      documents: documents ?? this.documents,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
      validation:    validation??this.   validation
    );
  }
}
