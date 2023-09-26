// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../auth/accounts/domain/repositories/auth_repo.dart';
import '../../../auth/accounts/domain/repositories/user_repo.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../core/utils/enums/enums.dart';

import '../repositories/update_profile_repo.dart';

class VeifyPhoneUseCase {
  final UpdateProfileRepo updateProfileRepo;
   final UserRepo userRepo;
  final AuthRepo authRepo;
  VeifyPhoneUseCase({
    required this.updateProfileRepo,
     required this.userRepo,
    required this.authRepo,
  });

  Future<Either<Failure, Unit>> call({
    required String phone,
    required String code,
    required TypeAuth typeAuth,
  }) async {
    final res = await updateProfileRepo.verifyUserPhone(
      phone: phone,
      phoneCode: code,
      typeAuth: typeAuth,
    );
    return   await res.fold(
      (l) {
        return Left(l);
      },
      (_) async {
        final dataInfo = await userRepo.getUserData(typeAuth: typeAuth);
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
