// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'accept_schedule_bloc.dart';

abstract class AcceptScheduleEvent extends Equatable {
  const AcceptScheduleEvent();

  @override
  List<Object> get props => [];
}
class AcceptEvent extends AcceptScheduleEvent {
  final int providerId;
  final int requestId;
  AcceptEvent({
    required this.providerId,
    required this.requestId,
  });
}
