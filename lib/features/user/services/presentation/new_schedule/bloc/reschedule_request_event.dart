// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'reschedule_request_bloc.dart';

abstract class RescheduleRequestEvent extends Equatable {
  const RescheduleRequestEvent();

  @override
  List<Object> get props => [];
}
class RescheduleEvent extends RescheduleRequestEvent {
  final  DateTime scheduleTime;
  final DateTime scheduleDate;
  final int requestId;
  final int providerId;
  RescheduleEvent({
   required this.scheduleTime,
    required this.scheduleDate,
    required this.requestId,
    required this.providerId,
  });
}
