// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'set_provider_notification_settings_bloc.dart';

abstract class SetNotificationSettingsEvent extends Equatable {
  const SetNotificationSettingsEvent();

  @override
  List<Object> get props => [];
}
class SetNotificationEvent extends SetNotificationSettingsEvent {
  final ProviderNotificationSettingsModel data;
  SetNotificationEvent({
    required this.data,
  });
}
