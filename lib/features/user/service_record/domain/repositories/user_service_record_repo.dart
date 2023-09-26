import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/history_request_user_entity.dart';
import '../entities/upcoming_request_user_entity.dart';

abstract class UserServiceRecordRepo{
   Future<Either<Failure,List<HistoryRequestUserEntity>>> getRequestsHistoryUser(
      {required int page});
  Future<Either<Failure,List<UpcomingRequestUserEntity>>> getRequestsUpcomingUser(
      {required int page});
      Future<Either<Failure,Unit>> rate(
      {required int rating,
      required int requestId,
      String comment = '',
       required bool isFav});
}
