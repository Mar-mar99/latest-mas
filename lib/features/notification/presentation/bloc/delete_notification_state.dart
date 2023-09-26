part of 'delete_notification_bloc.dart';

abstract class DeleteNotificationState extends Equatable {
  const DeleteNotificationState();

  @override
  List<Object> get props => [];
}

class DeleteNotificationInitial extends DeleteNotificationState {}
class LoadingDeleteNotificationn extends DeleteNotificationState{}
class DoneDeleteNotification extends DeleteNotificationState {
 
}
class DeleteNotificationOfflineState extends DeleteNotificationState{}
class DeleteNotificationErrorState extends DeleteNotificationState {
  final String message;
  const DeleteNotificationErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

