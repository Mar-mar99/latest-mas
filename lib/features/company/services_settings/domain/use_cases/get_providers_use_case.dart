// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:masbar/features/company/services_settings/data/model/company_provider_model.dart';
import 'package:masbar/features/company/services_settings/domain/repositories/services_repo.dart';

import '../../../../../core/errors/failures.dart';

import '../entities/company_provider_entity.dart';

class GetProvidersUseCase {
  final ServicesRepo servicesRepo;
  GetProvidersUseCase({
    required this.servicesRepo,
  });

  Future<Either<Failure, List<CompanyProviderEntity>>> call() async {
    final data = await servicesRepo.getProviders();
    return data.fold((f) => Left(f), (providers) => Right(providers));
  }
}
