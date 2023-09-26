// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/notification_settings_entity.dart';
import '../repositories/notification_settings_repo.dart';

class GetNotificationSettingsUseCase {
  final NotificationSettingsRepo notificationSettingsRepo;
  GetNotificationSettingsUseCase({
    required this.notificationSettingsRepo,
  });

Future<Either<Failure, NotificationSettingsEntity>>  call()async{
    final res = await notificationSettingsRepo.getSettings();
    return res.fold((l) => Left(l), (r) => Right(r));
}
}
