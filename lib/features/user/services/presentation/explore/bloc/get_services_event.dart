// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_services_bloc.dart';

abstract class GetServicesEvent extends Equatable {
  const GetServicesEvent();

  @override
  List<Object> get props => [];
}
class LoadServicesEvent extends GetServicesEvent {
  final int id;
  LoadServicesEvent({
    required this.id,
  });
}
