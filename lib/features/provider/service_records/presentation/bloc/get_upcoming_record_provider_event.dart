part of 'get_upcoming_record_provider_bloc.dart';

abstract class GetUpcomingRecordProviderEvent extends Equatable {
  const GetUpcomingRecordProviderEvent();

  @override
  List<Object> get props => [];
}
class GetProviderUpcomingtRequestsEvent extends GetUpcomingRecordProviderEvent {
   final bool refresh;
  GetProviderUpcomingtRequestsEvent({
     this.refresh=false,
  });
}
