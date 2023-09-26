// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../domain/entities/notification_settings_entity.dart';

class NotificationSettingsWidget extends StatelessWidget {
  final NotificationSettingsEntity data;
  const NotificationSettingsWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildNotificationTimeListTile(),
        const Divider(
          height: 8,
        ),
        _buildSnoozing()
      ],
    );
  }

  Widget _buildSnoozing() {
    return ListTile(
      title: Text(
        data.enableSnooze ? 'Snoozing is On' : 'Snoozing is Off ',
        style: TextStyle(
          fontSize: 16,
          color: data.enableSnooze ? null : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: data.enableSnooze
          ? const Icon(Icons.alarm_on)
          : const Icon(Icons.alarm_off_rounded),
      subtitle: data.enableSnooze
          ? Text(
              'Snooze evey: ${data.snoozeEvery} minutes',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }

  ListTile _buildNotificationTimeListTile() {
    return ListTile(
      title: Text(
        'Default Notification Time',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        'Before ${data.remindMeBefore} minutes',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      leading: const Icon(Icons.notifications_active),
    );
  }
}
