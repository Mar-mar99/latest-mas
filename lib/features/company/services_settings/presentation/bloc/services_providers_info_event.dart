part of 'services_providers_info_bloc.dart';

abstract class ServicesProvidersInfoEvent extends Equatable {
  const ServicesProvidersInfoEvent();

  @override
  List<Object> get props => [];
}

class LoadInfoEvent extends ServicesProvidersInfoEvent{}
