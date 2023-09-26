// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'promos_details_bloc.dart';

abstract class PromosDetailsEvent extends Equatable {
  const PromosDetailsEvent();

  @override
  List<Object> get props => [];
}
class LoadPromosDetailsEvent extends PromosDetailsEvent {
  final int id;
  LoadPromosDetailsEvent({
    required this.id,
  });
}
