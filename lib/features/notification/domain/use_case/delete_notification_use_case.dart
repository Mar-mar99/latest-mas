
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/enums/enums.dart';
import '../repositories/notification_repo.dart';

class DeleteNotificationUseCase {
  final NotificationRepo notificationRepo;

  DeleteNotificationUseCase({
    required this.notificationRepo,

  });
  Future<Either<Failure, Unit>> call({required TypeAuth typeAuth,required int id,}) async {
    final res = await notificationRepo.deleteNotification(typeAuth: typeAuth, id: id);
    return res.fold(
      (f) {
        return Left(f);
      },
      (_) async {
        return Right(unit);
      },
    );
  }
}
