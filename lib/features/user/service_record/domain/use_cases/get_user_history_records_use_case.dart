// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/history_request_user_entity.dart';
import '../entities/upcoming_request_user_entity.dart';
import '../repositories/user_service_record_repo.dart';

class GetUserHistoryRecordsUseCase {
  final UserServiceRecordRepo userServiceRecordRepo;
  GetUserHistoryRecordsUseCase({
    required this.userServiceRecordRepo,
  });

  Future<Either<Failure, List<HistoryRequestUserEntity>>> call(
      {required int page}) async {
    final res = await userServiceRecordRepo.getRequestsHistoryUser(page: page);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
