part of 'get_promos_services_bloc.dart';

abstract class GetPromosServicesState extends Equatable {
  const GetPromosServicesState();

  @override
  List<Object> get props => [];
}

class GetPromosServicesInitial extends GetPromosServicesState {}

class LoadingGetPromosServices extends GetPromosServicesState {}

class LoadedGetPromosServices extends GetPromosServicesState {
  final List<OfferServiceEntity> data;
  LoadedGetPromosServices({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class GetPromosServicesOfflineState extends GetPromosServicesState {}

class GetPromosServicesErrorState extends GetPromosServicesState {
  final String message;
  const GetPromosServicesErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
