part of 'check_for_service_bloc.dart';

abstract class CheckForServiceEvent extends Equatable {
  const CheckForServiceEvent();

  @override
  List<Object> get props => [];
}

class CheckEvent extends CheckForServiceEvent{}


