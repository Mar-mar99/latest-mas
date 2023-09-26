import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/history_request_user_entity.dart';
import '../entities/upcoming_request_user_entity.dart';
import '../repositories/user_service_record_repo.dart';

class GetUserUpcomingRecordsUseCase {
  final UserServiceRecordRepo userServiceRecordRepo;
  GetUserUpcomingRecordsUseCase({
    required this.userServiceRecordRepo,
  });

  Future<Either<Failure, List<UpcomingRequestUserEntity>>> call(
      {required int page}) async {
    final res = await userServiceRecordRepo.getRequestsUpcomingUser(page: page);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
