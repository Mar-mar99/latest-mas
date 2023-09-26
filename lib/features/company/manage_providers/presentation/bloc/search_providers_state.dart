part of 'search_providers_bloc.dart';

abstract class SearchProvidersState extends Equatable {
  const SearchProvidersState();

  @override
  List<Object> get props => [];
}

class SearchProvidersInitial extends SearchProvidersState {}

class LoadingSearchProviders extends SearchProvidersState {}

class LoadedSearchProviders extends SearchProvidersState {

  final List<ProviderEntity> data;
  LoadedSearchProviders({
    required this.data
  });

  @override
  List<Object> get props => [data];
}

class SearchProvidersOfflineState extends SearchProvidersState {}

class SearchProvidersNetworkErrorState extends SearchProvidersState {
  final String message;
  const SearchProvidersNetworkErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
