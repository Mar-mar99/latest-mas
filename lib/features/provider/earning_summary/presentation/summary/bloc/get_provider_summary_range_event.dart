// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_provider_summary_range_bloc.dart';

abstract class GetProviderSummaryRangeEvent extends Equatable {
  const GetProviderSummaryRangeEvent();

  @override
  List<Object> get props => [];
}
class GetProviderSummaryRange extends GetProviderSummaryRangeEvent {
final DateTime start;
final DateTime end;
  GetProviderSummaryRange({
    required this.start,
    required this.end,
  });
}
