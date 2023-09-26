import '../../../../../core/utils/enums/enums.dart';

import 'apple_remote_data_source.dart';
import 'facebook_remote_data_source.dart';
import 'google_remote_data_source.dart';
import '../models/social_user_model.dart';
abstract class SocialRemoteDataSource {
  Future<SocialUserModel> fetchSocialUser();
}

class SocialSource {
  SocialRemoteDataSource fetchLoggingMethod(SocialLoginType socialLoginType) {
    switch (socialLoginType) {
      case SocialLoginType.google:
        return GoogleRemoteDataSource();
      case SocialLoginType.facebook:
        return FacebookRemoteDataSource();
      case SocialLoginType.apple:
        return AppleRemoteDataSource();
    }
  }
}
