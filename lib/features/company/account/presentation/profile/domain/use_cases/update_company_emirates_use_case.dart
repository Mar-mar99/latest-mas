import 'package:dartz/dartz.dart';

import '../../../../../../../core/errors/failures.dart';

import '../repositories/company_profile_repo.dart';

class UpdateCompanyEmiratesUseCase {
  final CompanyProfileRepo companyProfileRepo;
  UpdateCompanyEmiratesUseCase({
    required this.companyProfileRepo,
  });
  Future<Either<Failure, Unit>> call(
      {required List<int> states, required int headState}) async {
    final res = await companyProfileRepo.updateCompanyEmirates(
        states: states, headState: headState);
    return res.fold((l) => Left(l), (r) => Right(unit));
  }
}
