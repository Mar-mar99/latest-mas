// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../auth/accounts/domain/repositories/auth_repo.dart';
import '../../../auth/accounts/domain/repositories/user_repo.dart';
import '../repositories/update_profile_repo.dart';

class UpdateProviderProfileUseCase {
  final UpdateProfileRepo updateProfileRepo;
   final UserRepo userRepo;
  final AuthRepo authRepo;
  UpdateProviderProfileUseCase({
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
    final res = await updateProfileRepo.updateProviderProfile(
      firstName: firstName,
      lastName: lastName,
      state: state,
    );
   return await res.fold(
      (l) {
        return Left(l);
      },
      (_) async {
        final dataInfo = await userRepo.getUserData(typeAuth: TypeAuth.provider);
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
