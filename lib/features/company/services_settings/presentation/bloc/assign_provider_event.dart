// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'assign_provider_bloc.dart';

abstract class AssignProviderEvent extends Equatable {
  const AssignProviderEvent();

  @override
  List<Object> get props => [];
}
class AssignProviderToServiceEvent extends AssignProviderEvent {
  final int serviceId;
  final int providerId;
  AssignProviderToServiceEvent({
    required this.serviceId,
    required this.providerId,
  });
}
