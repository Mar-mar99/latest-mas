import '../../domain/entities/notification_settings_entity.dart';

class NotificationSettingsModel extends NotificationSettingsEntity {
  NotificationSettingsModel(
      {required super.remindMeBefore,
      required super.enableSnooze,
      required super.snoozeEvery});
  factory NotificationSettingsModel.fromJson(Map<String, dynamic> data) {
    return NotificationSettingsModel(
      remindMeBefore: data['remind_me_before'],
      enableSnooze: data['enable_snooze']==1?true:false,
      snoozeEvery: data['snooze_every'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "remind_me_before": remindMeBefore,
      "enable_snooze": enableSnooze,
      "snooze_every": snoozeEvery
    };
  }
}
