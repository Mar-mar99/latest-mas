part of 'get_fav_providers_bloc.dart';

abstract class GetFavProvidersState extends Equatable {
  const GetFavProvidersState();

  @override
  List<Object> get props => [];
}

class GetFavProvidersInitial extends GetFavProvidersState {}

class LoadingGetFavProviders extends GetFavProvidersState {}

class LoadedGetFavProviders extends GetFavProvidersState {
  final List<FavoriteProviderEntity> data;
  LoadedGetFavProviders({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class GetFavProvidersOfflineState extends GetFavProvidersState {}

class GetFavProvidersErrorState extends GetFavProvidersState {
  final String message;
  const GetFavProvidersErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
