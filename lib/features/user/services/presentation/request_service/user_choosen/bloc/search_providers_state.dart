// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_providers_bloc.dart';

abstract class SearchProvidersState extends Equatable {
  const SearchProvidersState();

  @override
  List<Object> get props => [];
}

class SearchProvidersInitial extends SearchProvidersState {}

class LoadingSearchProviders extends SearchProvidersState{}
class LoadedSearchProviders extends SearchProvidersState {
  final List<ServiceProviderEntity> online;
  final List<ServiceProviderEntity> offline;
  final List<ServiceProviderEntity> busy;
  final int requestId;
  LoadedSearchProviders ({
    required this.online,
    required this.offline,
    required this.busy,
    required this.requestId,
  });

  @override

  List<Object> get props => [online,offline,busy,requestId];
}


class SearchProvidersOfflineState extends SearchProvidersState{}

class SearchProvidersErrorState extends SearchProvidersState {
  final String message;
  const SearchProvidersErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

