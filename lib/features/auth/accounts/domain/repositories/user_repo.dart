import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/domain/entities/user_entity.dart';
import 'package:masbar/features/auth/accounts/domain/use%20cases/login_usecase.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/social_user_entity.dart';

abstract class UserRepo {
  Future<Either<Failure, UserEntity>> signupProvider({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String code,
    required String password,
    required String confirmPassword,
    required List<File> documents,
  });
  Future<Either<Failure, UserEntity>> signupCompany({
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
  });
  Future<Either<Failure, UserEntity>> signupUser(
      {required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String phone,
      required int state});
  Future<Either<Failure, UserEntity>> loggin(
    String email,
    String password,
    LoginUserType type,
  );
  Future<Either<Failure, UserEntity>> loginSocialUser(
      {required SocialUserEntity socialUserEntity,
      required int state,
      required SocialLoginType socialLoginType});

  Future<Either<Failure, UserEntity>> getUserData({
    required TypeAuth typeAuth,
  });
  Future<Either<Failure, Unit>> logOut({
    required TypeAuth typeAuth,
  });
}
