// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:masbar/features/company/user_activity/domain/entities/requets_detail_entity.dart';
import 'package:masbar/features/company/user_activity/domain/entities/service_history_entity.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/expert_activity_entity.dart';
import '../../domain/repositories/user_activity_repo.dart';
import '../data_source/user_activity_data_source.dart';

class UserActivityRepoImpl implements UserActivityRepo {
  final UserActivityDataSource userActivityDataSource;
  UserActivityRepoImpl({
    required this.userActivityDataSource,
  });

  @override
  Future<Either<Failure,  Tuple2<int, List<UserActivityEntity>>>> getExpertsActivity(
      {int page = 1}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await userActivityDataSource.getExpertsActivity(page: page);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, List<ServiceHistoryEntity>>> getExpertPastRequestsForCompany({int page = 1, DateTime? fromDate, DateTime? toDate, String? providerId,})async {
 final data = await BaseRepo.repoRequest(request: () async {
      return await userActivityDataSource.getExpertPastRequestsForCompany(page: page,fromDate: fromDate,toDate: toDate,providerId: providerId);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, List<ServiceHistoryEntity>>> getExpertUpcomingRequestsForCompany({int page = 1, DateTime? fromDate, DateTime? toDate, String? providerId,}) async{
    final data = await BaseRepo.repoRequest(request: () async {
      return await userActivityDataSource.getExpertUpcomingRequestsForCompany(page: page,fromDate: fromDate,toDate: toDate,providerId: providerId);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, RequestDetailEntity>> getRequestDetails({required String id})async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await userActivityDataSource.getRequestDetails(id: id);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }
}
