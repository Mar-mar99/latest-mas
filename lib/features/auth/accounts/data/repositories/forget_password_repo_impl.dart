// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:masbar/core/errors/exceptions.dart';

import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/core/utils/enums/enums.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../../../../core/network/check_internet.dart';
import '../../domain/repositories/forget_password_repo.dart';
import '../data sources/forget_password_data_source.dart';

class ForgetPasswordRepoImpl implements ForgetPasswordRepo {
  ForgetPasswordDataSource forgetPasswordDataSource;

  ForgetPasswordRepoImpl({
    required this.forgetPasswordDataSource,
  });

  @override
  Future<Either<Failure, int>> sendEmail(
      {required String email, required TypeAuth typeAuth}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await await forgetPasswordDataSource.sendEmail(
          email: email,
          typeAuth: typeAuth,
        );
        ;
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> submitNewPassword(
      {required int id,
      required String password,
      required String confirmPassword,
      required String otp,
      required TypeAuth typeAuth}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await forgetPasswordDataSource.submitNewPassword(
          id: id,
          password: password,
          confirmPassword: confirmPassword,
          otp: otp,
          typeAuth: typeAuth,
        );
        ;
      },
    );
    return data.fold((f) => Left(f), (_) => Right(unit));
  }
}
