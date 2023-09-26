part of 'services_providers_info_bloc.dart';

abstract class ServicesProvidersInfoState extends Equatable {
  const ServicesProvidersInfoState();

  @override
  List<Object> get props => [];
}

class ServicesProvidersInfoInitial extends ServicesProvidersInfoState {}

class LoadingServicesProvidersInfoState extends ServicesProvidersInfoState {}

class LoadedServicesProvidersInfoState extends ServicesProvidersInfoState {
  final List<CompanyProviderEntity> providers;
  LoadedServicesProvidersInfoState({

    required this.providers,
  });

  @override
  List<Object> get props => [ providers];
}

class ServicesProvidersInfoOfflineState extends ServicesProvidersInfoState {}

class ServicesProvidersInfoNetworkErrorState
    extends ServicesProvidersInfoState {
  final String message;
  const ServicesProvidersInfoNetworkErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
