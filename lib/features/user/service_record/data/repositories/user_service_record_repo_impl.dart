import 'package:dartz/dartz.dart';

import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/features/auth/accounts/data/data%20sources/user_remote_data_source.dart';
import 'package:masbar/features/user/service_record/domain/entities/history_request_user_entity.dart';
import 'package:masbar/features/user/service_record/domain/entities/upcoming_request_user_entity.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../domain/repositories/user_service_record_repo.dart';
import '../data_source/user_service_record_data_source.dart';

class UserServiceRecordRepoImpl implements UserServiceRecordRepo {
  final UserServiceRecordsDataSource userServiceRecordsSource;
  UserServiceRecordRepoImpl({
    required this.userServiceRecordsSource,
  });
  @override
  Future<Either<Failure, List<HistoryRequestUserEntity>>>
      getRequestsHistoryUser({required int page}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await userServiceRecordsSource.getRequestsHistoryUser(page: page);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, List<UpcomingRequestUserEntity>>>
      getRequestsUpcomingUser({required int page}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await userServiceRecordsSource.getRequestsUpcomingUser(page: page);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> rate({
    required int rating,
    required int requestId,
    String comment = '',
     required bool isFav
  }) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await userServiceRecordsSource.rate(
        rating: rating,
        requestId: requestId,
        comment: comment,
        isFav: isFav
      );
    });
    return data.fold((f) => Left(f), (_) => Right(unit));
  }
}
