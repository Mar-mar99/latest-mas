// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'end_bloc.dart';

abstract class EndEvent extends Equatable {
  const EndEvent();

  @override
  List<Object> get props => [];
}
class CommentChangedEvent extends EndEvent {
  final String comment;
  CommentChangedEvent({
    required this.comment,
  });
}

class AddImageEndServiceEvent extends EndEvent {
 final File image;
  AddImageEndServiceEvent({
    required this.image,
  });
}


class RemoveImageEndServiceEvent extends EndEvent {
 final File image;
  RemoveImageEndServiceEvent({
    required this.image,
  });
}

class EndServiceEvent extends EndEvent {
  final int id;
  EndServiceEvent({
    required this.id,
  });
}
