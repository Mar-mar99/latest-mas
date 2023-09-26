// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'delete_location_bloc.dart';

abstract class DeleteLocationEvent extends Equatable {
  const DeleteLocationEvent();

  @override
  List<Object> get props => [];
}
class DeleteEvent extends DeleteLocationEvent {
  final int id;
  DeleteEvent({
    required this.id,
  });
}
