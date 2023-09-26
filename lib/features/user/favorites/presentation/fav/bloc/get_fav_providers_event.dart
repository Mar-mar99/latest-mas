// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_fav_providers_bloc.dart';

abstract class GetFavProvidersEvent extends Equatable {
  const GetFavProvidersEvent();

  @override
  List<Object> get props => [];
}

class LoadFavProvidersEvent extends GetFavProvidersEvent {
  final int serviceId;

  LoadFavProvidersEvent(
      {required this.serviceId, });
}
