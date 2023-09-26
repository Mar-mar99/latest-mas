import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:masbar/core/errors/exceptions.dart';
import 'package:masbar/features/auth/accounts/data/data%20sources/social_remote_data_source.dart';
import 'package:masbar/features/auth/accounts/data/models/social_user_model.dart';

class FacebookRemoteDataSource extends SocialRemoteDataSource {
  @override
  Future<SocialUserModel> fetchSocialUser() async {
    try{
        final LoginResult loginResult = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile', 'user_birthday'],
    );
    final userFacebook = await FacebookAuth.instance.getUserData();
    var name = userFacebook['name'];
    print('facebook name $name');
    var spaceIndex = name!.indexOf('');
    var firstName = spaceIndex == 0 ? name : name.substring(0, spaceIndex);
    var lastName =
        spaceIndex == 0 ? '' : name.substring(spaceIndex + 1, name.length);

    return SocialUserModel(
      firstName: firstName,
      lastName: lastName,
      email: userFacebook['email'] as String,
      photo: userFacebook['picture']['data']['url'] as String,
      id: userFacebook['id'],
    );
    }on Exception {
      throw ExceptionOther();
    }
  }
}
