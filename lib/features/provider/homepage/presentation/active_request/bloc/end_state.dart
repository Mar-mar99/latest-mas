// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'end_bloc.dart';

class EndState extends Equatable {
  final int requestId;
  final List<File> images;
  final String comment;
  final FormSubmissionState formSubmissionState;
  final InvoiceEntity? invoiceEntity;
  const EndState({
    required this.requestId,
    required this.images,
    required this.comment,
    required this.formSubmissionState,
    this.invoiceEntity,
  });

  factory EndState.empty() {
    return EndState(
        comment: '',
        formSubmissionState: InitialFormState(),
        images: [],
        requestId: 0);
  }

  @override
  List<Object> get props => [
        requestId,
        images,
        comment,
        formSubmissionState,
        invoiceEntity.toString()
      ];

  EndState copyWith({
    int? requestId,
    List<File>? images,
    String? comment,
    FormSubmissionState? formSubmissionState,
    InvoiceEntity? invoiceEntity,
  }) {
    return EndState(
      requestId: requestId ?? this.requestId,
      images: images ?? this.images,
      comment: comment ?? this.comment,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
      invoiceEntity: invoiceEntity ?? this.invoiceEntity,
    );
  }
}
