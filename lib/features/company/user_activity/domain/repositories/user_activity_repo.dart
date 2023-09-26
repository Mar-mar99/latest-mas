import 'package:dartz/dartz.dart';
import 'package:masbar/core/errors/failures.dart';

import '../entities/expert_activity_entity.dart';
import '../entities/requets_detail_entity.dart';
import '../entities/service_history_entity.dart';

abstract class UserActivityRepo {
  Future<Either<Failure, Tuple2<int, List<UserActivityEntity>>>> getExpertsActivity(
      {int page = 1});
  Future<Either<Failure, List<ServiceHistoryEntity>>>
      getExpertUpcomingRequestsForCompany({
    int page = 1,
    DateTime? fromDate,
    DateTime? toDate,
    String? providerId,
  });
  Future<Either<Failure, List<ServiceHistoryEntity>>>
      getExpertPastRequestsForCompany({
    int page = 1,
    DateTime? fromDate,
    DateTime? toDate,
    String? providerId,
  });
   Future<Either<Failure,RequestDetailEntity>> getRequestDetails({required String id});
}
