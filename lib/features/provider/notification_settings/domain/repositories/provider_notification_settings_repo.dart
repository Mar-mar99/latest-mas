import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../data/model/provider_notification_settings_model.dart';

import '../entities/provider_notification_settings_entity.dart';

abstract class ProviderNotificationSettingsRepo {
  Future<Either<Failure, ProviderNotificationSettingsEntity>> getSettings();
  Future<Either<Failure, Unit>> setSettings(ProviderNotificationSettingsModel data);
}
