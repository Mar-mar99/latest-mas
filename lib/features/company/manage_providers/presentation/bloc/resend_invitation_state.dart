part of 'resend_invitation_bloc.dart';

abstract class ResendInvitationState extends Equatable {
  const ResendInvitationState();

  @override
  List<Object> get props => [];
}

class ResendInvitationInitial extends ResendInvitationState {}
class LoadingResendInvitationState extends ResendInvitationState{}
class DoneResendInvitationState extends ResendInvitationState {

}


class ResendInvitationOfflineState extends ResendInvitationState{}

class ResendInvitationStateErrorState extends ResendInvitationState {
  final String message;
  const ResendInvitationStateErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}


