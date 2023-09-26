import 'package:masbar/core/errors/exceptions.dart';
import 'package:masbar/features/auth/accounts/data/data%20sources/social_remote_data_source.dart';
import 'package:masbar/features/auth/accounts/data/models/social_user_model.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class GoogleRemoteDataSource extends SocialRemoteDataSource {
  @override
  Future<SocialUserModel> fetchSocialUser() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleSignInAccount;

      googleSignInAccount = await googleSignIn.signIn();

      var name = googleSignIn.currentUser!.displayName;
      var spaceIndex = name!.indexOf('');
      var firstName = spaceIndex == 0 ? name : name.substring(0, spaceIndex);
      var lastName =
          spaceIndex == 0 ? '' : name.substring(spaceIndex + 1, name.length);
      var email = googleSignIn.currentUser!.email;
      var photo = googleSignIn.currentUser!.photoUrl;
      var id = googleSignIn.currentUser!.id;

      return SocialUserModel(
          firstName: firstName,
          lastName: lastName,
          email: email,
          photo: photo!,
          id: id);
    } on Exception {
      throw ExceptionOther();
    }
  }
}
