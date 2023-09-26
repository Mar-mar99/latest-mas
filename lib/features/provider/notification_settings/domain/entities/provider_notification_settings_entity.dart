// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ProviderNotificationSettingsEntity extends Equatable {
  final num remindMeBefore;
  final bool enableSnooze;
  final num snoozeEvery;
  ProviderNotificationSettingsEntity({
    required this.remindMeBefore,
    required this.enableSnooze,
    required this.snoozeEvery,
  });

  @override
  List<Object?> get props => [
        remindMeBefore,
        enableSnooze,
        snoozeEvery,
      ];
}
