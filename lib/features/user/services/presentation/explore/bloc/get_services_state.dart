// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_services_bloc.dart';

abstract class GetServicesState extends Equatable {
  const GetServicesState();

  @override
  List<Object> get props => [];
}

class GetServicesInitial extends GetServicesState {}


class LoadingGetService extends GetServicesState{}
class LoadedGetService extends GetServicesState {
  final List<ServiceEntity> services;
  LoadedGetService({
    required this.services,
  });

  @override

  List<Object> get props => [services];
}


class GetServiceOfflineState extends GetServicesState{}

class GetServiceErrorState extends GetServicesState {
  final String message;
  const GetServiceErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

