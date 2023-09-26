import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/service_entity.dart';
import '../entities/service_info_entity.dart';
import '../repositories/explore_services_repo.dart';

class GetServiceInfoUseCase{
 final ExploreServicesRepo exploreServicesRepo;
  GetServiceInfoUseCase({
    required this.exploreServicesRepo,
  });

  Future<Either<Failure, ServiceInfoEntity>> call({required  int serviceId,required int stateId}) async {
    final res = await exploreServicesRepo.getServiceDetails(serviceId: serviceId, stateId: stateId);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}

