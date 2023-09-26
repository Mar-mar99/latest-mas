// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/service_history_entity.dart';
import '../repositories/user_activity_repo.dart';

class GetExpertUpcomingUseCase {
  final UserActivityRepo userActivityRepo;
  GetExpertUpcomingUseCase({
    required this.userActivityRepo,
  });
  Future<Either<Failure, List<ServiceHistoryEntity>>> call({
    int page = 1,
    DateTime? fromDate,
    DateTime? toDate,
    String? providerId,
  }) async {
    final res = await userActivityRepo.getExpertUpcomingRequestsForCompany(
      fromDate: fromDate,
      page: page,
      providerId: providerId,
      toDate: toDate,
    );
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
