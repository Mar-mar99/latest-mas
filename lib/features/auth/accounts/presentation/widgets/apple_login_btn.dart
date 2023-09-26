import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/presentation/bloc/social_login_bloc.dart';

import 'package:provider/provider.dart' as p;

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLoginBtn extends StatelessWidget {
  const AppleLoginBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInWithAppleButton(
      onPressed: () {
      BlocProvider.of<SocialLoginBloc>(
          context,
        ).add(
          FetchSocialUserEvent(
            socialLoginType: SocialLoginType.apple,
          ),
        );   },
      style: SignInWithAppleButtonStyle.black,
    );
  }
}
