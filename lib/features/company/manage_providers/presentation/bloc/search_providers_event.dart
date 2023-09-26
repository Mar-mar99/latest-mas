// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_providers_bloc.dart';

abstract class SearchProvidersEvent extends Equatable {
  const SearchProvidersEvent();

  @override
  List<Object> get props => [];
}
class SearchEvent extends SearchProvidersEvent {
final String key;
  SearchEvent({
    required this.key,
  });
}
