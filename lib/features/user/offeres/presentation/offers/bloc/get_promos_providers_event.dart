// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_promos_providers_bloc.dart';

abstract class GetPromosProvidersEvent extends Equatable {
  const GetPromosProvidersEvent();

  @override
  List<Object> get props => [];
}
class LoadProvidersEvent extends GetPromosProvidersEvent {
  final int serviceId;
  final String keyword;
  LoadProvidersEvent({
    required this.serviceId,
     this.keyword='',
  });
}
