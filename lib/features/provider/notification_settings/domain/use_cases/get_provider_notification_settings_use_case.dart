// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/provider_notification_settings_entity.dart';
import '../repositories/provider_notification_settings_repo.dart';

class GetProviderNotificationSettingsUseCase {
  final ProviderNotificationSettingsRepo notificationSettingsRepo;
  GetProviderNotificationSettingsUseCase({
    required this.notificationSettingsRepo,
  });

Future<Either<Failure, ProviderNotificationSettingsEntity>>  call()async{
    final res = await notificationSettingsRepo.getSettings();
    return res.fold((l) => Left(l), (r) => Right(r));
}
}
