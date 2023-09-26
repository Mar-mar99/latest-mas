// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_state_bloc.dart';

class EditStateState extends Equatable {
  final int state;
  final FormSubmissionState formSubmissionState;
  const EditStateState({
    required this.state,
    required this.formSubmissionState,
  });
  factory EditStateState.empty() {
    return const EditStateState(
      state: 0,
      formSubmissionState: InitialFormState(),
    );
  }
  @override
  List<Object> get props => [state, formSubmissionState];

  EditStateState copyWith({
    int? state,
    FormSubmissionState? formSubmissionState,
  }) {
    return EditStateState(
      state: state ?? this.state,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
    );
  }
}
