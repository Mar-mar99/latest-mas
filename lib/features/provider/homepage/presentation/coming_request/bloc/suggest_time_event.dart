// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'suggest_time_bloc.dart';

abstract class SuggestTimeEvent extends Equatable {
  const SuggestTimeEvent();

  @override
  List<Object> get props => [];
}
class SuggestAnotherTimeEvent extends SuggestTimeEvent {
  final int requestId;
  final DateTime date;
  final DateTime time;
  SuggestAnotherTimeEvent({
    required this.requestId,
    required this.date,
    required this.time,
  });
}
