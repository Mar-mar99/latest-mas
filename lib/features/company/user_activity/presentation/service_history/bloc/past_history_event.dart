// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'past_history_bloc.dart';

abstract class PastHistoryEvent extends Equatable {
  const PastHistoryEvent();

  @override
  List<Object> get props => [];
}
class LoadFirstTimePastRequestsEvent extends PastHistoryEvent {

}

class LoadMorePastRequestsEvent extends PastHistoryEvent {

}

class DateOrProviderChangedEvent extends PastHistoryEvent {
  final DateTime from;
  final DateTime to;
  final String? providerId;
  DateOrProviderChangedEvent({
    required this.from,
    required this.to,
     this.providerId,
  });
}
