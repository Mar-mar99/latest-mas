// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_password_bloc.dart';

class EditPasswordState extends Equatable {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final FormSubmissionState formSubmissionState;
  const EditPasswordState({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
    required this.formSubmissionState,
  });

  factory EditPasswordState.empty() {
    return const EditPasswordState(
        currentPassword: '',
        confirmPassword: '',
        newPassword: '',
        formSubmissionState: InitialFormState());
  }

  @override
  List<Object> get props =>
      [currentPassword, newPassword, confirmPassword, formSubmissionState];

  EditPasswordState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    FormSubmissionState? formSubmissionState,
  }) {
    return EditPasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
    );
  }
}
