import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/domain/entities/social_user_entity.dart';
import '../../../../../core/api_service/base_repo.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repo.dart';
import '../data sources/user_remote_data_source.dart';

class UserRepoImpl implements UserRepo {
  UserRemoteDataSource userRemoteDataSource;

  UserRepoImpl({
    required this.userRemoteDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> loggin(
    String email,
    String password,
    LoginUserType type,
  ) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await userRemoteDataSource.loggin(
          email,
          password,
          type,
        );
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, UserEntity>> signupUser(
      {required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String phone,
      required int state}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await userRemoteDataSource.signupUser(
          email: email,
          firstName: firstName,
          lastName: lastName,
          password: password,
          phone: phone,
          state: state,
        );
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
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
  }) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await userRemoteDataSource.signupCompany(
          address: address,
          companyName: companyName,
          companyOwnerType: companyOwnerType,
          confirmPassword: confirmPassword,
          documents: documents,
          email: email,
          password: password,
          phone: phone,
          providerCount: providerCount,
          state: state,
          mainBranch: mainBranch,
          verifyByType: verifyByType);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, UserEntity>> signupProvider({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String code,
    required String password,
    required String confirmPassword,
    required List<File> documents,
  }) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await userRemoteDataSource.signupProvider(
          confirmPassword: confirmPassword,
          documents: documents,
          email: email,
          password: password,
          phone: phone,
          code: code,
          firstName: firstName,
          lastName: lastName);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, UserEntity>> loginSocialUser(
      {required SocialUserEntity socialUserEntity,
      required int state,
      required SocialLoginType socialLoginType}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await userRemoteDataSource.socialLogin(
        socialUserEntity: socialUserEntity,
        state: state,
        loginType: socialLoginType,
      );
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, UserEntity>> getUserData({
    required TypeAuth typeAuth,
  }) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await userRemoteDataSource.getUserData(
        typeAuth: typeAuth,
      );
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> logOut({required TypeAuth typeAuth}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await userRemoteDataSource.logOut(
        typeAuth: typeAuth,
      );
    });
     return data.fold((f) => Left(f), (_) => Right(unit));
  }
}
