
part of 'user_signup_bloc.dart';

enum SignupValidation {
  init,
  stateNotSelected,
}

class UserSignupState extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
   final String phone;
   final int state;
  final String password;
  final String confirmPassword;
  final SignupValidation validation;
  final FormSubmissionState formSubmissionState;
  UserSignupState({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.state,
    required this.password,
    required this.confirmPassword,
    required this.validation,
    required this.formSubmissionState,
  });


  factory UserSignupState.empty() {
    return  UserSignupState(
        firstName: '',
        email: '',
        password: '',
        lastName: '',
        phone: '',
        state: 0,
        confirmPassword: '',
        validation: SignupValidation.init,
        formSubmissionState: const InitialFormState(),);
  }

  @override
  List<Object> get props => [
        firstName,
        lastName,
        email,
        phone,
        state,
        password,
        confirmPassword,
        validation,
        formSubmissionState,
      ];



  UserSignupState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    int? state,
    String? password,
    String? confirmPassword,
    SignupValidation? validation,
    FormSubmissionState? formSubmissionState,
  }) {
    return UserSignupState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      state: state ?? this.state,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      validation: validation ?? this.validation,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
    );
  }
}
