import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';

import '../../../../documents_company/presentation/screens/documents_screen.dart';
import '../bloc/authentication_bloc.dart';
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(

      appBar:AppBar(
   title: Text(
      AppLocalizations.of(context)?.onBoarding ?? ""),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 95),
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      height: 95,
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  AppText(
                    AppLocalizations.of(context)
                            ?.onBoardingAccessPendingApproval ??
                        "",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: AppText(
                      AppLocalizations.of(context)?.onBoardingMessage ?? "",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 7.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: AppText(
                      AppLocalizations.of(context)?.onBoardingThankYou ?? "",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: AppButton(
                            title: AppLocalizations.of(context)
                                    ?.onBoardingLogout ??
                                "",
                            onTap: () {
                                  BlocProvider.of<AuthenticationBloc>(context)
                                            .add(LogOutUserEvent());
                            }),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        child: AppButton(
                            title: AppLocalizations.of(context)?.document ?? "",
                            buttonColor: ButtonColor.transparentBorderPrimary,
                            onTap: () {
                               Navigator.pushNamed(context, DocumentsScreen.routeName);
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
