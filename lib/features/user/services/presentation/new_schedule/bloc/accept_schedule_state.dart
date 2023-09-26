part of 'accept_schedule_bloc.dart';

abstract class AcceptScheduleState extends Equatable {
  const AcceptScheduleState();

  @override
  List<Object> get props => [];
}

 class AcceptScheduleInitial extends AcceptScheduleState {}

class LoadingAcceptSchedule extends AcceptScheduleState{}
class LoadedAcceptSchedule extends AcceptScheduleState {

}


class AcceptScheduleOfflineState extends AcceptScheduleState{}

class AcceptScheduleErrorState extends AcceptScheduleState {
  final String message;
  const AcceptScheduleErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

