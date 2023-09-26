import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/company_provider_entity.dart';
import '../repositories/services_repo.dart';

class GetServiceAssignedProviderUseCase{
  final ServicesRepo servicesRepo;
  GetServiceAssignedProviderUseCase({
    required this.servicesRepo,
  });

  Future<Either<Failure, List<CompanyProviderEntity>>> call({required int serviceId}) async {
    final data = await servicesRepo.getServiceAssignedProviders(serviceId: serviceId);
    return data.fold((f) => Left(f), (providers) => Right(providers));
  }
}
