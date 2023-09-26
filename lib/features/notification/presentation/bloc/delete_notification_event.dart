// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'delete_notification_bloc.dart';

abstract class DeleteNotificationEvent extends Equatable {
  const DeleteNotificationEvent();

  @override
  List<Object> get props => [];
}
class DeleteEvent extends DeleteNotificationEvent {
  final TypeAuth typeAuth;
  final int id;
  DeleteEvent({
    required this.typeAuth,
    required this.id,
  });

}
