// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'comapny_summary_bloc.dart';

abstract class ComapnySummaryEvent extends Equatable {
  const ComapnySummaryEvent();

  @override
  List<Object> get props => [];
}

class GetCompanySummaryDataWithProviders extends ComapnySummaryEvent {
  final DateTime start;
  final DateTime end;

  GetCompanySummaryDataWithProviders({
    required this.start,
    required this.end,

  });
}

class GetCompanySummaryDataWithoutProviders extends ComapnySummaryEvent {
  final DateTime start;
  final DateTime end;
  final String? providerId;

  GetCompanySummaryDataWithoutProviders({
    required this.start,
    required this.end,
    this.providerId

  });
}
