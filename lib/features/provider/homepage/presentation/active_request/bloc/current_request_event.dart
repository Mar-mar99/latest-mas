part of 'current_request_bloc.dart';

abstract class CurrentRequestEvent extends Equatable {
  const CurrentRequestEvent();

  @override
  List<Object> get props => [];
}
class GetCurrentRequestEvent extends CurrentRequestEvent{}

class RefreshCurrentRequestEvent extends CurrentRequestEvent{}
