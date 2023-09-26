import 'package:dartz/dartz.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/company_service_entity.dart';
import '../../domain/repositories/company_services_repo.dart';
import '../data_source/company_services_data_source.dart';

class CompanyServicesRepoImpl implements CompanyServicesRepo{
   final CompanyServicesDataSource companyServicesDataSource;
  CompanyServicesRepoImpl({
    required this.companyServicesDataSource,
  });

  @override
  Future<Either<Failure, List<CompanyServiceEntity>>>
      getCompanyServices() async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await companyServicesDataSource.getCompanyServices();
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

}
