part of 'fetch_offline_requests_bloc.dart';

abstract class FetchOfflineRequestsEvent extends Equatable {
  const FetchOfflineRequestsEvent();

  @override
  List<Object> get props => [];
}
class GetOfflineRequestsEvent extends FetchOfflineRequestsEvent{
  
}
