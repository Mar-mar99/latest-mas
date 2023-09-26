import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import '../../../../../core/errors/failures.dart';

import '../repositories/user_repo.dart';

class CompanySignupUseCase {
  final UserRepo userRepo;
  final AuthRepo authRepo;

  CompanySignupUseCase({
    required this.userRepo,
    required this.authRepo,
  });

  Future<Either<Failure, Unit>> call({
  required CompanyOwnerType companyOwnerType,
  required String companyName,
  required String email,
  required String phone,
  required List<int> state,
  required int mainBranch,
  required int providerCount,
  required String address,
  required String password,
  required String confirmPassword,
  required List<File> documents,
  required VerifyByType verifyByType,

  }) async {
    final res = await userRepo.signupCompany(
      companyOwnerType: companyOwnerType,
      companyName: companyName,
      email: email,
      phone: phone,
      state: state,
      mainBranch: mainBranch,
      providerCount: providerCount,
      address: address,
      password: password,
      confirmPassword: confirmPassword,
      documents: documents,
      verifyByType: verifyByType,
    );
    return res.fold(
      (f) {
        return Left(f);
      },
      (userEntity) async {
        await authRepo.saveUserData(userEntity);
        await authRepo.saveToken(userEntity.accessToken!);
        return const Right(unit);
      },
    );
  }
}
