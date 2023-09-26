import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/services_repo.dart';

class AssignProviderUseCase{
 final ServicesRepo servicesRepo;
  AssignProviderUseCase({
    required this.servicesRepo,
  });

  Future<Either<Failure, Unit>> call({
     required int providerId,
     required int serviceId,
   }) async {
    final data = await servicesRepo.assignProviderToService(serviceId: serviceId, providerId: providerId);
    return data.fold((f) => Left(f), (_) => Right(unit));
  }
}
