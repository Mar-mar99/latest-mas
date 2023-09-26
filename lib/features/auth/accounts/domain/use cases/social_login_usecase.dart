// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/domain/entities/social_user_entity.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/auth_repo.dart';
import '../repositories/user_repo.dart';

class SocialLoginUseCase {
  final UserRepo userRepo;
  final AuthRepo authRepo;
  SocialLoginUseCase({
    required this.userRepo,
    required this.authRepo,
  });

  Future<Either<Failure, Unit>> call(
      {required SocialUserEntity socialUserEntity,
      required int state,
      required SocialLoginType socialLoginType}) async {
    final res = await userRepo.loginSocialUser(
      socialUserEntity: socialUserEntity,
      state: state,
      socialLoginType: socialLoginType,
    );
    return res.fold(
      (f) {
        return Left(f);
      },
      (userEntity) async {
        await authRepo.saveUserData(userEntity);
        print('typeeee ${userEntity.type}');
        await authRepo.saveToken(userEntity.accessToken!);
        return const Right(unit);
      },
    );
  }
}
