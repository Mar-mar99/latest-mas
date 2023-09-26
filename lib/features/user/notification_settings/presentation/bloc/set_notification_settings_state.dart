part of 'set_notification_settings_bloc.dart';

abstract class SetNotificationSettingsState extends Equatable {
  const SetNotificationSettingsState();

  @override
  List<Object> get props => [];
}

class SetNotificationSettingsInitial extends SetNotificationSettingsState {}
class LoadingSetNotificationSettings extends SetNotificationSettingsState {}

class LoadedSetNotificationSettings extends SetNotificationSettingsState {

}


class SetNotificationSettingsOfflineState extends SetNotificationSettingsState{}

class SetNotificationSettingsErrorState extends SetNotificationSettingsState {
  final String message;
  const SetNotificationSettingsErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

