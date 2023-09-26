// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'service_details_bloc.dart';

abstract class ServiceDetailsEvent extends Equatable {
  const ServiceDetailsEvent();

  @override
  List<Object> get props => [];
}
class FetchInfoEvent extends ServiceDetailsEvent {
  final   int serviceId;
  final int stateId;

  FetchInfoEvent({
    required this.serviceId,
    required this.stateId,
  });
}

