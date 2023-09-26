import 'package:dartz/dartz.dart';
import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/domain/entities/social_user_entity.dart';

abstract class SocialRepo {
  Future<Either<Failure, SocialUserEntity>> fetchSocialUser({
    required SocialLoginType socialLoginType,
  });


}
