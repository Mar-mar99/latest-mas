// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../core/utils/helpers/helpers.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repo.dart';

class GetNotificationUseCase {
  final NotificationRepo notificationRepo;

  GetNotificationUseCase({
    required this.notificationRepo,
  });
  Future<Either<Failure, List<NotificationEntity>>> call(
      {required int page, required TypeAuth typeAuth}) async {
        print('use case');
    final res = await notificationRepo.getNotifications(page: page, typeAuth: typeAuth);
    return res.fold(
      (f) {
        return Left(f);
      },
      (noti) async {
        return Right(noti);
      },
    );
  }
}
