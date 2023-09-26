// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/core/utils/enums/enums.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/network/check_internet.dart';
import '../../domain/repositories/verify_account_repo.dart';
import '../data sources/verify_account_data_source.dart';

class VerifyAccountRepoImpl implements VerifyAccountRepo {
  final VerifyAccountDataSource verifyAccountDataSource;

  VerifyAccountRepoImpl(
      {required this.verifyAccountDataSource, NetworkApiServiceHttp});
  @override
  Future<Either<Failure, Unit>> resendCode(
      {required TypeAuth auth, }) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await verifyAccountDataSource.resendCode(auth: auth, );
    });
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> verifyAccount(
      {required String otp,
      required TypeAuth auth,
    }) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await verifyAccountDataSource.verifyAccount(
          otp: otp, auth: auth, );
    });
    return data.fold((f) => Left(f), (data) => Right(unit));
  }
}
