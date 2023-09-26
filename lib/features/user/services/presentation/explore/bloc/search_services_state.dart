// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_services_bloc.dart';

class SearchServicesState extends Equatable {
  final double distance;
  final String type;
  final String keyword;
  final FormSubmissionState formSubmissionState;
  final List<ServiceEntity> data;
  const SearchServicesState(
      {required this.distance,
      required this.type,
      required this.keyword,
      required this.formSubmissionState,
      required this.data});
  factory SearchServicesState.empty() {
    return const SearchServicesState(
        distance: 0,
        keyword: '',
        type: '',
        formSubmissionState: InitialFormState(),
        data: []);
  }
  @override
  List<Object> get props =>
      [distance, type, keyword, formSubmissionState, data];

  SearchServicesState copyWith(
      {double? distance,
      String? type,
      String? keyword,
      FormSubmissionState? formSubmissionState,
      List<ServiceEntity>? data}) {
    return SearchServicesState(
      distance: distance ?? this.distance,
      type: type ?? this.type,
      keyword: keyword ?? this.keyword,
      data: data ?? this.data,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
    );
  }
}
