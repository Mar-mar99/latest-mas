import 'package:dartz/dartz.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/domain/entities/social_user_entity.dart';

import 'package:masbar/features/auth/accounts/domain/repositories/social_repo.dart';
import '../../../../../core/errors/failures.dart';

class FetchSocialUserUseCase {
  final SocialRepo socialRepo;

  FetchSocialUserUseCase({
    required this.socialRepo,
  });

  Future<Either<Failure, SocialUserEntity>> call({
    required SocialLoginType socialLoginType,
  }) async {
    final res =
        await socialRepo.fetchSocialUser(socialLoginType: socialLoginType);
    return res.fold(
      (f) {
        return Left(f);
      },
      (socialUserEntity) async {
        return Right(socialUserEntity);
      },
    );
  }
}
