import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../data/model/provider_notification_settings_model.dart';
import '../repositories/provider_notification_settings_repo.dart';

class SetProviderNotificationSettingsUseCase{
   final ProviderNotificationSettingsRepo notificationSettingsRepo;
  SetProviderNotificationSettingsUseCase({
    required this.notificationSettingsRepo,
  });

Future<Either<Failure, Unit>> call(ProviderNotificationSettingsModel data)async{
    final res = await notificationSettingsRepo.setSettings(data);
    return res.fold((l) => Left(l), (r) => Right(r));
}
}
