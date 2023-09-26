part of 'get_assigned_providers_bloc.dart';

abstract class GetAssignedProvidersState extends Equatable {
  const GetAssignedProvidersState();

  @override
  List<Object> get props => [];
}

class GetAssignedProvidersInitial extends GetAssignedProvidersState {}

class LoadingGetAssignedProvidersInfoState extends GetAssignedProvidersState {}

class LoadedGetAssignedProvidersInfoState extends GetAssignedProvidersState {
  final List<CompanyProviderEntity> allProviders;
  final List<CompanyProviderEntity> assignedProviders;
  LoadedGetAssignedProvidersInfoState({
    required this.assignedProviders,
    required this.allProviders,
  });

  @override
  List<Object> get props => [assignedProviders, allProviders];
}

class GetAssignedProvidersInfoOfflineState extends GetAssignedProvidersState {}

class GetAssignedProvidersNetworkErrorState extends GetAssignedProvidersState {
  final String message;
  const GetAssignedProvidersNetworkErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
