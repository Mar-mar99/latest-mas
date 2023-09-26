part of 'get_fav_services_bloc.dart';

abstract class GetFavServicesState extends Equatable {
  const GetFavServicesState();

  @override
  List<Object> get props => [];
}

class GetFavServicesInitial extends GetFavServicesState {}

class LoadingGetFavServices extends GetFavServicesState {}

class LoadedGetFavServices extends GetFavServicesState {
  final List<FavoriteServiceEntity> data;
  LoadedGetFavServices({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class GetFavServicesOfflineState extends GetFavServicesState {}

class GetFavServicesErrorState extends GetFavServicesState {
  final String message;
  const GetFavServicesErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
