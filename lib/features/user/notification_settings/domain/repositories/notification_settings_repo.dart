import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../data/model/notification_settings_model.dart';
import '../entities/notification_settings_entity.dart';

abstract class NotificationSettingsRepo {
  Future<Either<Failure, NotificationSettingsEntity>> getSettings();
  Future<Either<Failure, Unit>> setSettings(NotificationSettingsModel data);
}
