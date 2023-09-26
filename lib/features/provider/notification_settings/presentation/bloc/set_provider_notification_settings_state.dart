part of 'set_provider_notification_settings_bloc.dart';

abstract class SetProviderNotificationSettingsState extends Equatable {
  const SetProviderNotificationSettingsState();

  @override
  List<Object> get props => [];
}

class SetNotificationSettingsInitial extends SetProviderNotificationSettingsState {}
class LoadingSetNotificationSettings extends SetProviderNotificationSettingsState {}

class LoadedSetNotificationSettings extends SetProviderNotificationSettingsState {

}


class SetNotificationSettingsOfflineState extends SetProviderNotificationSettingsState{}

class SetNotificationSettingsErrorState extends SetProviderNotificationSettingsState {
  final String message;
  const SetNotificationSettingsErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

