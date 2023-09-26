part of 'delete_invitation_bloc.dart';

abstract class DeleteInvitationState extends Equatable {
  const DeleteInvitationState();

  @override
  List<Object> get props => [];
}

class DeleteInvitationInitial extends DeleteInvitationState {}
class LoadingDeleteInvitationState extends DeleteInvitationState{}
class DoneDeleteInvitationState extends DeleteInvitationState {

}


class DeleteInvitationOfflineState extends DeleteInvitationState{}

class DeleteInvitationStateErrorState extends DeleteInvitationState {
  final String message;
  const DeleteInvitationStateErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}


