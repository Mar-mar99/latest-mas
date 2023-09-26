// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_card_bloc.dart';

class AddCardState extends Equatable {

  final FormSubmissionState formSubmissionState;
  const AddCardState({
    required this.formSubmissionState,
  });
  factory AddCardState.empty() {
    return const AddCardState(

        formSubmissionState: InitialFormState());
  }
  @override
  List<Object> get props => [ formSubmissionState];

  AddCardState copyWith({

    FormSubmissionState? formSubmissionState,
  }) {
    return AddCardState(

      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
    );
  }
}
