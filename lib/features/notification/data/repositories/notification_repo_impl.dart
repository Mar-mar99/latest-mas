// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/features/notification/domain/entities/notification_entity.dart';

import '../../../../core/api_service/base_repo.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/check_internet.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../domain/repositories/notification_repo.dart';
import '../data_source/notification_data_source.dart';

class NotificationRepoImpl extends NotificationRepo {
  final NotificationDataSource notificationDataSource;

  NotificationRepoImpl({
    required this.notificationDataSource,

  });
  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications(
      {
        required int page,
        required TypeAuth typeAuth, }) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await notificationDataSource.getNotifications(
          typeAuth: typeAuth,
          page: page

        );
      },
    );
      return data.fold((f) => Left(f), (data) => Right(data ));
  }

  @override
  Future<Either<Failure, Unit>> deleteNotification(
      {required TypeAuth typeAuth, required int id}) async{
       final data = await BaseRepo.repoRequest(
      request: () async {
        return await notificationDataSource.deleteNotification(typeAuth: typeAuth, id: id);
      },
    );
      return data.fold((f) => Left(f), (_) => Right(unit ));
  }
}
