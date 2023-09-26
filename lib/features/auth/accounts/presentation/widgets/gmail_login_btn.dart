// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/presentation/bloc/social_login_bloc.dart';

class GmailLoginBtn extends StatelessWidget {
  const GmailLoginBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        BlocProvider.of<SocialLoginBloc>(
          context,
        ).add(
          FetchSocialUserEvent(
            socialLoginType: SocialLoginType.google,
          ),
        );
      },
      icon: Image.asset(
        "assets/images/googleLogo.png",
        width: 20,
        height: 20,
      ),
      label: Text(
        AppLocalizations.of(context)!.continueWithGoogle,
        style: const TextStyle(
          color: Colors.black87,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: Colors.white,
        elevation: 1,
        side: BorderSide(width: 2.0, color: Colors.grey.shade300),
      ),
    );
  }
}
