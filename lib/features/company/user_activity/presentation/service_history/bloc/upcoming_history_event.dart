part of 'upcoming_history_bloc.dart';

abstract class UpcomingHistoryEvent extends Equatable {
  const UpcomingHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadFirstTimeUpcomingRequestsEvent extends UpcomingHistoryEvent {

}

class LoadMoreUpcomingRequestsEvent extends UpcomingHistoryEvent {

}

class DateOrProviderChangedEvent extends UpcomingHistoryEvent {
  final DateTime from;
  final DateTime to;
  final String? providerId;
  DateOrProviderChangedEvent({
    required this.from,
    required this.to,
     this.providerId,
  });
}

