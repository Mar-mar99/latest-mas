import 'package:dartz/dartz.dart';
import 'package:masbar/core/errors/failures.dart';

import '../../../../core/utils/enums/enums.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepo {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    required int page,
    required TypeAuth typeAuth,

  });
    Future<Either<Failure,Unit>> deleteNotification(
      {required TypeAuth typeAuth, required int id});
}
