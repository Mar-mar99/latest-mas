import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/request_past_provider_entity.dart';
import '../entities/request_upcoming_provider_entity.dart';

abstract class ServiceRecordProviderRepo{
    Future<Either<Failure,List<RequestPastProviderEntity>>> getRequestsHistoryProvider(
      {required int page});

  Future<Either<Failure,List<RequestUpcomingProviderEntity>>> getRequestsUpcomingProvider(
      {required int page});

  Future<Either<Failure,Unit>> rate({
    required int rating,
    required int requestId,
    String comment = '',
  });
}
