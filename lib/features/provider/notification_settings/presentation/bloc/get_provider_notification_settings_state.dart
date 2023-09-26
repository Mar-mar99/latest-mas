part of 'get_provider_notification_settings_bloc.dart';

abstract class GetProviderNotificationSettingsState extends Equatable {
  const GetProviderNotificationSettingsState();

  @override
  List<Object> get props => [];
}

class GetNotificationSettingsInitial extends GetProviderNotificationSettingsState {}
class LoadingGetNotificationSettings extends GetProviderNotificationSettingsState {}

class LoadedGetNotificationSettings extends GetProviderNotificationSettingsState {
  final ProviderNotificationSettingsEntity data;
  LoadedGetNotificationSettings({
    required this.data,
  });
  @override

  List<Object> get props => [data];
}


class GetNotificationSettingsOfflineState extends GetProviderNotificationSettingsState{}

class GetNotificationSettingsErrorState extends GetProviderNotificationSettingsState {
  final String message;
  const GetNotificationSettingsErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

