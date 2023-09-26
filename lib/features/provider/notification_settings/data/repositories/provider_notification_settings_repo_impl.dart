// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:masbar/core/errors/failures.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../domain/entities/provider_notification_settings_entity.dart';
import '../../domain/repositories/provider_notification_settings_repo.dart';
import '../data_sources/provider_notification_settings_data_source.dart';
import '../model/provider_notification_settings_model.dart';

class ProviderNotificationSettingsRepoImpl implements ProviderNotificationSettingsRepo {
final ProviderNotificationSettingsDataSource dataSource;
  ProviderNotificationSettingsRepoImpl({
    required this.dataSource,
  });

  @override
  Future<Either<Failure, ProviderNotificationSettingsEntity>> getSettings() async{
   final returnedData = await BaseRepo.repoRequest(request: () async {
      return await dataSource.getSettings();
    });
    return returnedData.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> setSettings(ProviderNotificationSettingsModel data)async {
   final returnedData = await BaseRepo.repoRequest(request: () async {
      return await dataSource.setSettings(data);
    });
    return returnedData.fold((f) => Left(f), (_) => Right(unit));
  }
}
