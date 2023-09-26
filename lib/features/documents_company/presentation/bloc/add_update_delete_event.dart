// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_update_delete_bloc.dart';

abstract class AddUpdateDeleteEvent extends Equatable {
  const AddUpdateDeleteEvent();

  @override
  List<Object> get props => [];
}

class AddDocumentEvent extends AddUpdateDeleteEvent {
  final File file;
  AddDocumentEvent({
    required this.file,
  });
  @override
  List<Object> get props => [file];
}

class UpdateDocumentEvent extends AddUpdateDeleteEvent {
  final File file;
  final int id;
  UpdateDocumentEvent({
    required this.file,
    required this.id
  });
  @override
  List<Object> get props => [file,id];
}

class DeleteDocumentEvent extends AddUpdateDeleteEvent {

  final int id;
  DeleteDocumentEvent({

    required this.id
  });
  @override
  List<Object> get props => [id];
}
