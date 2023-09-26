// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_assigned_providers_bloc.dart';

abstract class GetAssignedProvidersEvent extends Equatable {
  const GetAssignedProvidersEvent();

  @override
  List<Object> get props => [];
}

class GetAssignedProvidersAndAllProviders extends GetAssignedProvidersEvent {
  final int serviceId;
  GetAssignedProvidersAndAllProviders({
    required this.serviceId,
  });
}
