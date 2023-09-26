// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/features/user/notification_settings/data/model/notification_settings_model.dart';
import 'package:masbar/features/user/notification_settings/domain/entities/notification_settings_entity.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../../../notification/domain/repositories/notification_repo.dart';
import '../../domain/repositories/notification_settings_repo.dart';
import '../data_sources/notification_settings_data_source.dart';

class NotificationSettingsRepoImpl implements NotificationSettingsRepo {
final NotificationSettingsDataSource dataSource;
  NotificationSettingsRepoImpl({
    required this.dataSource,
  });

  @override
  Future<Either<Failure, NotificationSettingsEntity>> getSettings() async{
   final returnedData = await BaseRepo.repoRequest(request: () async {
      return await dataSource.getSettings();
    });
    return returnedData.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> setSettings(NotificationSettingsModel data)async {
   final returnedData = await BaseRepo.repoRequest(request: () async {
      return await dataSource.setSettings(data);
    });
    return returnedData.fold((f) => Left(f), (_) => Right(unit));
  }
}
