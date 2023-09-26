part of 'get_promos_providers_bloc.dart';

abstract class GetPromosProvidersState extends Equatable {
  const GetPromosProvidersState();

  @override
  List<Object> get props => [];
}

class GetPromosProvidersInitial extends GetPromosProvidersState {}

class LoadingGetPromosProviders extends GetPromosProvidersState {}

class LoadedGetPromosProviders extends GetPromosProvidersState {
  final List<OfferProviderEntity> data;
  LoadedGetPromosProviders({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class GetPromosProvidersOfflineState extends GetPromosProvidersState {}

class GetPromosProvidersErrorState extends GetPromosProvidersState {
  final String message;
  const GetPromosProvidersErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
