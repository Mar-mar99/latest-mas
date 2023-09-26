// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'accepting_rejecting_bloc.dart';

abstract class AcceptingRejectingEvent extends Equatable {
  const AcceptingRejectingEvent();

  @override
  List<Object> get props => [];
}

class AcceptRequestEvent extends AcceptingRejectingEvent {
  final int id;
  AcceptRequestEvent({
    required this.id,
  });
}

class RejectRequestEvent extends AcceptingRejectingEvent{
    final int id;
  RejectRequestEvent({
    required this.id,
  });
}
