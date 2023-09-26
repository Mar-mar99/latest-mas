// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/company_service_entity.dart';
import '../repositories/company_services_repo.dart';


class GetCompanyServicesUseCase {
  final CompanyServicesRepo companyServicesRepo;
  GetCompanyServicesUseCase({
    required this.companyServicesRepo,
  });

  Future<Either<Failure, List<CompanyServiceEntity>>> call() async {
    final res = await companyServicesRepo.getCompanyServices();
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
