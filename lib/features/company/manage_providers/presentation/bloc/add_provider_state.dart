// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_provider_bloc.dart';

enum InviteProviderValidation { init, stateNotSelected }

class AddProviderState extends Equatable {
  final String firstName;
  final String lastName;
  final String phone;
  final int state;
  final FormSubmissionState formSubmissionState;
  final InviteProviderValidation validation;
  AddProviderState(
      {required this.firstName,
      required this.lastName,
      required this.state,
      required this.phone,
      required this.formSubmissionState,
      required this.validation});
  factory AddProviderState.empty() {
    return AddProviderState(
      firstName: '',
      lastName: '',
      phone: '',
      state: 0,
      validation: InviteProviderValidation.init,
      formSubmissionState: const InitialFormState(),
    );
  }

  @override
  List<Object?> get props =>
      [firstName, lastName, state, phone, formSubmissionState, validation];

  AddProviderState copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    int? state,
    FormSubmissionState? formSubmissionState,
    InviteProviderValidation? validation,
  }) {
    return AddProviderState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      state: state ?? this.state,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
      validation: validation ?? this.validation,
    );
  }

  @override
  bool get stringify => true;
}
