part of 'remove_provider_bloc.dart';

abstract class RemoveProviderEvent extends Equatable {
  const RemoveProviderEvent();

  @override
  List<Object> get props => [];
}
class RemoveProviderFromServiceEvent extends RemoveProviderEvent {
  final int serviceId;
  final int providerId;
  RemoveProviderFromServiceEvent({
    required this.serviceId,
    required this.providerId,
  });
}
