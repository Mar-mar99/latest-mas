// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'resend_invitation_bloc.dart';

abstract class ResendInvitationEvent extends Equatable {
  const ResendInvitationEvent();

  @override
  List<Object> get props => [];
}
class ResendEvent extends ResendInvitationEvent {
  final int id;
  ResendEvent({
    required this.id,
  });
}
