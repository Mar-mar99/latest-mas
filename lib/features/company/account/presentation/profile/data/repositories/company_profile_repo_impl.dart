// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:masbar/core/errors/failures.dart';

import 'package:masbar/features/company/account/presentation/profile/domain/entities/company_emirates_entity.dart';

import '../../../../../../../core/api_service/base_repo.dart';
import '../../domain/repositories/company_profile_repo.dart';
import '../date_source/company_profile_data_source.dart';

class CompanyProfileRepoImpl implements CompanyProfileRepo {
  final CompanyProfileDataSource companyProfileDataSource;
  CompanyProfileRepoImpl({
    required this.companyProfileDataSource,
  });

  @override
  Future<Either<Failure, List<CompanyEmiratesEntity>>>
      getCompanyEmirates() async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await companyProfileDataSource.getCompanyEmirates();
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> updateCompanyEmirates(
      {required List<int> states, required int headState}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await companyProfileDataSource.updateCompanyEmirates(
            states: states, headState: headState);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> updateAddress({required String address}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await companyProfileDataSource.updateAddress(address: address);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
  }
}
