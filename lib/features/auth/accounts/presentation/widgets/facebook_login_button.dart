import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/presentation/bloc/social_login_bloc.dart';

class FacebookLoginBtn extends StatelessWidget {
  const FacebookLoginBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        BlocProvider.of<SocialLoginBloc>(
          context,
        ).add(
          FetchSocialUserEvent(
            socialLoginType: SocialLoginType.facebook,
          ),
        ); },
      icon:const Icon(
        Icons.facebook,
        color: Colors.white,
      ),
      label: Text(
        AppLocalizations.of(context)!.continueWithFacebook,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: const Color(0xff24479B),
        elevation: 1,
        side: BorderSide(width: 2.0, color: Colors.grey.shade300),
      ),
    );
  }
}

