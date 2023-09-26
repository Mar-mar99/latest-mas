part of 'assign_provider_bloc.dart';

abstract class AssignProviderState extends Equatable {
  const AssignProviderState();

  @override
  List<Object> get props => [];
}

class AssignProviderInitial extends AssignProviderState {}

class LoadingAssignProvider extends AssignProviderState {}

class LoadedAssignProvider extends AssignProviderState {

}

class AssignProviderOfflineState extends AssignProviderState {}

class AssignProviderNetworkErrorState extends AssignProviderState {
  final String message;
  const AssignProviderNetworkErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
