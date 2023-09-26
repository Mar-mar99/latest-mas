// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_attributes_bloc.dart';

abstract class GetAttributesEvent extends Equatable {
  const GetAttributesEvent();

  @override
  List<Object> get props => [];
}
class ProviderIdChangedEvent extends GetAttributesEvent {
  final CompanyProviderEntity provider;
  final CompanyServiceEntity service;

  ProviderIdChangedEvent({
    required this.provider,
    required this.service

  });

}

// class ServiceIdChangedEvent extends GetAttributesEvent {
//   final CompanyServiceEntity service;

//   ServiceIdChangedEvent({
//     required this.service,

//   });

// }
