// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_services_bloc.dart';

abstract class SearchServicesEvent extends Equatable {
  const SearchServicesEvent();

  @override
  List<Object> get props => [];
}

class TypeChangedEvent extends SearchServicesEvent {
  final String type;
  TypeChangedEvent({
    required this.type,
  });
}
class DistanceChangedEvent extends SearchServicesEvent {
  final double distance;
  DistanceChangedEvent({
    required this.distance,
  });
}

class KeywordChangedEvent extends SearchServicesEvent {
  final String keyword;
  KeywordChangedEvent({
    required this.keyword,
  });
}
class FilterEvent extends SearchServicesEvent {
  final int? categoryId;
  FilterEvent({
     this.categoryId,
  });
}
