// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:masbar/core/errors/exceptions.dart';
import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/core/network/check_internet.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/data/data%20sources/user_remote_data_source.dart';
import 'package:masbar/features/auth/accounts/domain/entities/social_user_entity.dart';
import 'package:masbar/features/auth/accounts/domain/entities/user_entity.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../domain/repositories/social_repo.dart';
import '../data sources/social_remote_data_source.dart';

class SocialRepoImpl extends SocialRepo {
final SocialSource socialSource;
  final NetworkInfo networkInfo;
  SocialRepoImpl({
    required this.socialSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, SocialUserEntity>> fetchSocialUser(
      {required SocialLoginType socialLoginType}) async {

  final data = await BaseRepo.repoRequest(
      request: () async {
           SocialRemoteDataSource socialRemoteDataSource =socialSource.fetchLoggingMethod(socialLoginType);

        return  await socialRemoteDataSource.fetchSocialUser();

      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));

      }

}
