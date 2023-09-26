// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/features/provider/notification_settings/presentation/widgets/provider_number_picker_widget.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:masbar/core/ui/widgets/app_button.dart';

import '../../data/model/provider_notification_settings_model.dart';
import '../../domain/entities/provider_notification_settings_entity.dart';
import '../bloc/set_provider_notification_settings_bloc.dart';

class EditProviderNotificationSettingsWidget extends StatefulWidget {
  final ProviderNotificationSettingsEntity data;

  const EditProviderNotificationSettingsWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<EditProviderNotificationSettingsWidget> createState() =>
      _EditProviderNotificationSettingsWidgetState();
}

class _EditProviderNotificationSettingsWidgetState
    extends State<EditProviderNotificationSettingsWidget> {
  late String remindMeBefore;
  late bool isSnoozed;
  late String snoozeEvery;
  @override
  void initState() {
    super.initState();
    remindMeBefore = widget.data.remindMeBefore.toString();
    isSnoozed = widget.data.enableSnooze;
    snoozeEvery = widget.data.snoozeEvery.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: (MediaQuery.of(context).size.height - 32) * 0.8,
          child: Column(
            children: [
              _buildNotificationTimeListTile(),
              const Divider(
                height: 8,
              ),
              _buildSnoozing()
            ],
          ),
        ),
        _buildSaveBtn()
      ],
    );
  }

  Widget _buildSaveBtn() {
    return BlocBuilder<SetProviderNotificationSettingsBloc,
        SetProviderNotificationSettingsState>(
      builder: (context, state) {
        return AppButton(
          title: 'Save',
          isLoading: state is LoadingSetNotificationSettings,
          onTap: () {
            BlocProvider.of<SetProviderNotificationSettingsBloc>(context).add(
              SetNotificationEvent(
                data: ProviderNotificationSettingsModel(
                  remindMeBefore: num.parse(remindMeBefore),
                  enableSnooze: isSnoozed,
                  snoozeEvery: num.parse(
                    snoozeEvery,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSnoozing() {
    return SwitchListTile(
      value: isSnoozed,
      onChanged: (value) {
        setState(() {
          isSnoozed = !isSnoozed;
        });
      },
      title: Text(
        'Enable/Disable Snoozing',
        style: TextStyle(
          fontSize: 16,
          color: isSnoozed ? null : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
      secondary: isSnoozed
          ? const Icon(Icons.alarm_on)
          : const Icon(Icons.alarm_off_rounded),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isSnoozed
              ? Text(
                  'Snooze evey: $snoozeEvery minutes',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                )
              : Container(),
          if (isSnoozed)
            OutlinedButton(
                onPressed: () async {
                  _buildSnoozeEveryDialog();
                },
                child: Text(
                  'change',
                  style: TextStyle(fontSize: 14),
                ))
        ],
      ),
    );
  }

  Widget _buildNotificationTimeListTile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text(
            'Default Notification Time',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Before ${remindMeBefore} minutes',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          leading: const Icon(Icons.notifications_active),
          trailing: OutlinedButton(
              onPressed: () async {
                _buildRemindMeLatedDialog();
              },
              child: Text(
                'change',
                style: TextStyle(fontSize: 14),
              )),
        ),
      ],
    );
  }

  void _buildRemindMeLatedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Remind me before: (Min)'),
                ProviderNumberPickerWidget(
                  value: int.parse(remindMeBefore),
                  cancelHandler: () {
                    Navigator.pop(context);
                  },
                  okHandler: (selectedValue) {
                    Navigator.pop(context, selectedValue.toString());
                  },
                )
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          remindMeBefore = value.toString();
        });
      }
    });
  }

  void _buildSnoozeEveryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Snooze every: (Min)'),
                ProviderNumberPickerWidget(
                  value: int.parse(snoozeEvery),
                  cancelHandler: () {
                    Navigator.pop(context);
                  },
                  okHandler: (selectedValue) {
                    Navigator.pop(context, selectedValue.toString());
                  },
                )
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          snoozeEvery = value.toString();
        });
      }
    });
  }
}
