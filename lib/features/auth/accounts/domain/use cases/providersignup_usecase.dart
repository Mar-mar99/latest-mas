import 'package:masbar/features/auth/accounts/domain/repositories/user_repo.dart';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import '../../../../../core/errors/failures.dart';

import '../repositories/user_repo.dart';

class ProviderSignupUsecase {
  final UserRepo userRepo;
  final AuthRepo authRepo;

  ProviderSignupUsecase({
    required this.userRepo,
    required this.authRepo,
  });

  Future<Either<Failure, Unit>> call({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String code,
    required String password,
    required String confirmPassword,
    required List<File> documents,
  }) async {
    final res = await userRepo.signupProvider(
        confirmPassword: confirmPassword,
        documents: documents,
        email: email,
        password: password,
        phone: phone,
        code: code,
        firstName: firstName,
        lastName: lastName);
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
