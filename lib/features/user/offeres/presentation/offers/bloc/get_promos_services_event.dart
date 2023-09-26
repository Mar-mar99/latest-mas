// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_promos_services_bloc.dart';

abstract class GetPromosServicesEvent extends Equatable {
  const GetPromosServicesEvent();

  @override
  List<Object> get props => [];
}
class GetServiceEvent extends GetPromosServicesEvent {
  final int id;
  GetServiceEvent({
    required this.id,
  });
}
