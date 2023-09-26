part of 'remove_provider_bloc.dart';

abstract class RemoveProviderState extends Equatable {
  const RemoveProviderState();

  @override
  List<Object> get props => [];
}

class RemoveProviderInitial extends RemoveProviderState {}

class LoadingRemoveProvider extends RemoveProviderState {}

class LoadedRemoveProvider extends RemoveProviderState {

}

class RemoveProviderOfflineState extends RemoveProviderState {}

class RemoveProviderNetworkErrorState extends RemoveProviderState {
  final String message;
  const RemoveProviderNetworkErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
