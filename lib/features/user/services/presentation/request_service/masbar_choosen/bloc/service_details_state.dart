part of 'service_details_bloc.dart';

abstract class ServiceDetailsState extends Equatable {
  const ServiceDetailsState();

  @override
  List<Object> get props => [];
}

class ServiceDetailsInitial extends ServiceDetailsState {}

class LoadingServiceDetails extends ServiceDetailsState{}
class LoadedServiceDetails extends ServiceDetailsState {
  final ServiceInfoEntity info;
  LoadedServiceDetails({
    required this.info,
  });

  @override

  List<Object> get props => [info];
}


class ServiceDetailsOfflineState extends ServiceDetailsState{}

class ServiceDetailsErrorState extends ServiceDetailsState {
  final String message;
  const ServiceDetailsErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

