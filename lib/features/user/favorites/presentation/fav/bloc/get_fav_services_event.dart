// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_fav_services_bloc.dart';

abstract class GetFavServicesEvent extends Equatable {
  const GetFavServicesEvent();

  @override
  List<Object> get props => [];
}
class LoadFavServices extends GetFavServicesEvent {
  final int id;
  LoadFavServices({
    required this.id,
  });
}
