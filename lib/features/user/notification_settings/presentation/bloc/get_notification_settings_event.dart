part of 'get_notification_settings_bloc.dart';

abstract class GetNotificationSettingsEvent extends Equatable {
  const GetNotificationSettingsEvent();

  @override
  List<Object> get props => [];
}
class FetchNotificationSettingsEvent extends GetNotificationSettingsEvent{}
