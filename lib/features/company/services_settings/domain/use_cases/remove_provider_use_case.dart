import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/services_repo.dart';

class RemoveProviderUseCase{
  final ServicesRepo servicesRepo;
  RemoveProviderUseCase({
    required this.servicesRepo,
  });

  Future<Either<Failure, Unit>> call({
     required int providerId,
     required int serviceId,
   }) async {
    final data = await servicesRepo.removeProviderFromService(serviceId: serviceId, providerId: providerId);
    return data.fold((f) => Left(f), (_) => Right(unit));
  }
}
