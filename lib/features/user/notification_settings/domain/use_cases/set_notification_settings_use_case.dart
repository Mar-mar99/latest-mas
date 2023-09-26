import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../data/model/notification_settings_model.dart';
import '../repositories/notification_settings_repo.dart';

class SetNotificationSettingsUseCase{
   final NotificationSettingsRepo notificationSettingsRepo;
  SetNotificationSettingsUseCase({
    required this.notificationSettingsRepo,
  });

Future<Either<Failure, Unit>> call(NotificationSettingsModel data)async{
    final res = await notificationSettingsRepo.setSettings(data);
    return res.fold((l) => Left(l), (r) => Right(r));
}
}
