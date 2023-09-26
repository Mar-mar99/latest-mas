import 'package:dartz/dartz.dart';

import '../../../../../../../core/errors/failures.dart';
import '../entities/company_emirates_entity.dart';
import '../repositories/company_profile_repo.dart';

class GetCompanyEmiratesUseCase {
  final CompanyProfileRepo companyProfileRepo;
  GetCompanyEmiratesUseCase({
    required this.companyProfileRepo,
  });
  Future<Either<Failure, List<CompanyEmiratesEntity>>> call() async {
    final res = await companyProfileRepo.getCompanyEmirates();
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
