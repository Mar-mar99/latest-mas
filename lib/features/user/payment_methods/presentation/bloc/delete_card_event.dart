// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'delete_card_bloc.dart';

abstract class DeleteCardEvent extends Equatable {
  const DeleteCardEvent();

  @override
  List<Object> get props => [];
}

class DeleteEvent extends DeleteCardEvent {
  final String id;
  DeleteEvent({
    required this.id,
  });
}
