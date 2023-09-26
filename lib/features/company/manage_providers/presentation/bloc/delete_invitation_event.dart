// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'delete_invitation_bloc.dart';

abstract class DeleteInvitationEvent extends Equatable {
  const DeleteInvitationEvent();

  @override
  List<Object> get props => [];
}

class DeleteEvent extends DeleteInvitationEvent {
  final int id;
  DeleteEvent({
    required this.id,
  });
}
