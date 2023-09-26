// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_history_record_provider_bloc.dart';

abstract class GetHistoryRecordProviderEvent extends Equatable {
  const GetHistoryRecordProviderEvent();

  @override
  List<Object> get props => [];
}
class GetProviderPastRequestsEvent extends GetHistoryRecordProviderEvent {
  final bool refresh;
  GetProviderPastRequestsEvent({
     this.refresh=false,
  });
}
