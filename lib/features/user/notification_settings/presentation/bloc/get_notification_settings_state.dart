part of 'get_notification_settings_bloc.dart';

abstract class GetNotificationSettingsState extends Equatable {
  const GetNotificationSettingsState();

  @override
  List<Object> get props => [];
}

class GetNotificationSettingsInitial extends GetNotificationSettingsState {}
class LoadingGetNotificationSettings extends GetNotificationSettingsState {}

class LoadedGetNotificationSettings extends GetNotificationSettingsState {
  final NotificationSettingsEntity data;
  LoadedGetNotificationSettings({
    required this.data,
  });
  @override

  List<Object> get props => [data];
}


class GetNotificationSettingsOfflineState extends GetNotificationSettingsState{}

class GetNotificationSettingsErrorState extends GetNotificationSettingsState {
  final String message;
  const GetNotificationSettingsErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

