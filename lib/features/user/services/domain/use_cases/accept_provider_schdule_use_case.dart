import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/service_entity.dart';
import '../entities/service_info_entity.dart';
import '../repositories/explore_services_repo.dart';

class AcceptProviderScheduleUseCase{
    final ExploreServicesRepo exploreServicesRepo;
  AcceptProviderScheduleUseCase({
    required this.exploreServicesRepo,
  });

  Future<Either<Failure, Unit>> call({
    required int requestId,
    required int providerId,
  }) async {
    final res = await exploreServicesRepo.acceptProviderSechdule(providerId: providerId, requestId: requestId);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}

