import 'package:flutter/foundation.dart';
import 'package:masbar/core/errors/exceptions.dart';
import 'package:masbar/features/auth/accounts/data/data%20sources/social_remote_data_source.dart';
import 'package:masbar/features/auth/accounts/data/models/social_user_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleRemoteDataSource extends SocialRemoteDataSource {
  @override
  Future<SocialUserModel> fetchSocialUser() async {
    try{
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: '9V4ND8BUG2.com.jammal.masbar',
        redirectUri:
            // For web your redirect URI needs to be the host of the "current page",
            // while for Android you will be using the API server that redirects back into your app via a deep link
            kIsWeb
                ? Uri.parse(
                    'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple')
                : Uri.parse('https://masbar.firebaseapp.com/__/auth/handler'),
      ),
    );
    var name = credential.givenName;
    var spaceIndex = name!.indexOf('');
    var firstName = spaceIndex == 0 ? name : name.substring(0, spaceIndex);
    var lastName =
        spaceIndex == 0 ? '' : name.substring(spaceIndex + 1, name.length);
  print('$credential');
    return SocialUserModel(
      firstName: firstName,
      lastName: lastName,
      email: credential.email as String,
      photo: '',
      id: credential.userIdentifier as String,
    );
    }on Exception {
      throw ExceptionOther();
    }
  }
}
