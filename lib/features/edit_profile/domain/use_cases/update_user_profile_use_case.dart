// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/user_repo.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/update_profile_repo.dart';

class UpdateUserProfileUseCase {
  final UpdateProfileRepo updateProfileRepo;
  final UserRepo userRepo;
  final AuthRepo authRepo;
  UpdateUserProfileUseCase({
    required this.updateProfileRepo,
    required this.userRepo,
    required this.authRepo,
  });

  Future<Either<Failure, Unit>> call({
    required String firstName,
    required String lastName,
    required int state,
    File? avatar,
  }) async {
    final res = await updateProfileRepo.updateUserProfile(
      firstName: firstName,
      lastName: lastName,
      state: state,
      avatar: avatar,
    );
    return await res.fold(
      (l) {
        return Left(l);
      },
      (_) async {
        final dataInfo = await userRepo.getUserData(typeAuth: TypeAuth.user);
        return await dataInfo.fold(
          (l) {
            return Left(l);
          },
          (userEntity) async {
            await authRepo.saveUserData(userEntity);
           
            return const Right(unit);
          },
        );
      },
    );
  }
}
