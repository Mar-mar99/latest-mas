part of 'reschedule_request_bloc.dart';

abstract class RescheduleRequestState extends Equatable {
  const RescheduleRequestState();

  @override
  List<Object> get props => [];
}

 class RescheduleRequestInitial extends RescheduleRequestState {}

class LoadingRescheduleRequest extends RescheduleRequestState{}
class LoadedRescheduleRequest extends RescheduleRequestState {

}


class RescheduleRequestOfflineState extends RescheduleRequestState{}

class RescheduleRequestErrorState extends RescheduleRequestState {
  final String message;
  const RescheduleRequestErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

