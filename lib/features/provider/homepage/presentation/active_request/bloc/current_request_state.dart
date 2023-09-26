// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'current_request_bloc.dart';

abstract class CurrentRequestState extends Equatable {
  const CurrentRequestState();

  @override
  List<Object> get props => [];
}

class CurrentRequestInitial extends CurrentRequestState {}

class LoadingCurrentRequest extends CurrentRequestState {}

class RefreshingCurrentRequest extends CurrentRequestState {}


class LoadedCurrentRequest extends CurrentRequestState {
  final RequestProviderEntity? data;
  final bool hasCurrent;
  LoadedCurrentRequest({
     this.data,
    required this.hasCurrent,
  });

  @override
  List<Object> get props => [data.toString(),hasCurrent];
}

class RefreshedCurrentRequest extends CurrentRequestState {
  final RequestProviderEntity? data;
  final bool hasCurrent;
  RefreshedCurrentRequest({
     this.data,
    required this.hasCurrent,
  });

  @override
  List<Object> get props => [data.toString(),hasCurrent];
}

class CurrentRequestOfflineState extends CurrentRequestState {}

class CurrentRequestErrorState extends CurrentRequestState {
  final String message;
  const CurrentRequestErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
