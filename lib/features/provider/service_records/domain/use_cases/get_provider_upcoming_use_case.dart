import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/request_upcoming_provider_entity.dart';
import '../repositories/service_record_provider_repo.dart';

class GetProviderUpcomingUseCase{
  final ServiceRecordProviderRepo serviceRecordProviderRepo;
  GetProviderUpcomingUseCase({
    required this.serviceRecordProviderRepo,
  });
   Future<Either<Failure,List<RequestUpcomingProviderEntity>>> call(  {required int page}) async {
    final res =
        await serviceRecordProviderRepo.getRequestsUpcomingProvider(page: page);
    return res.fold((l) => Left(l), (r) => Right(r));
  
   }
}
