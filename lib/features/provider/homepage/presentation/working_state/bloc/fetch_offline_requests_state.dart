part of 'fetch_offline_requests_bloc.dart';

abstract class FetchOfflineRequestsState extends Equatable {
  const FetchOfflineRequestsState();

  @override
  List<Object> get props => [];
}

class FetchOfflineRequestsInitial extends FetchOfflineRequestsState {}

class LoadingFetchOfflineRequests extends FetchOfflineRequestsState {

}

class LoadedFetchOfflineRequests extends FetchOfflineRequestsState {
   final List<OfflineRequestEntity> data;
  LoadedFetchOfflineRequests({
    required this.data,
  });
}

class FetchOfflineRequestsOfflineState extends FetchOfflineRequestsState {}

class FetchOfflineRequestsErrorState extends FetchOfflineRequestsState {
  final String message;
  const FetchOfflineRequestsErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
