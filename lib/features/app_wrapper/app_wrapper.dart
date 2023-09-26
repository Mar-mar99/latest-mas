import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/core/utils/helpers/helpers.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';

import '../auth/accounts/presentation/bloc/authentication_bloc.dart';
import '../auth/accounts/presentation/screens/login_screen.dart';
import '../auth/accounts/presentation/screens/onboarding_screen.dart';
import '../auth/accounts/presentation/screens/otp_screen.dart';
import '../delete_account/presentation/bloc/delete_account_bloc.dart';
import '../delete_account/presentation/delete_account_listener.dart';
import '../navigation/screens/app_homepage_screen.dart';
import '../provider/homepage/presentation/working_state/bloc/submit_location_provider_bloc.dart';
import '../splash_screen/splash_screen.dart';

class AppWrapper extends StatelessWidget {
  static const routeName = 'wrapper_scrren';
  const AppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteAccountBloc, DeleteAccountState>(
      listener: (context, state) {
        deleteAccountListener(state, context);
      },
      child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          _buildAuthListener(state, context);
        },
        builder: (context, state) {
          return _buildAuthBuilder(state, context);
        },
      ),
    );
  }

  Widget _buildAuthBuilder(AuthenticationState state, BuildContext context) {
    print('the auth state ${state.runtimeType}');
    if (state is AuthenticationInitial || state is AuthenticatationLoading) {
      return const SplashScreen();
    } else if (state is UnauthenticatedState) {
      return LoginScreen();
    } else if (state is VerificataionState) {
      return OTPScreen();
    } else if (state is OnBoardingState) {
      return const OnboardingScreen();
    } else if (state is AuthenticatedState) {
      return AppHomepageScreen(
        typeAuth: Helpers.getUserTypeEnum(
          context.read<AuthRepo>().getUserData()!.type!,
        ),
      );
    } else {
      return const SplashScreen();
    }
  }

  void _buildAuthListener(AuthenticationState state, BuildContext context) {
    if (state is UnauthenticatedState) {
      BlocProvider.of<SubmitLocationProviderBloc>(context).add(
        StopSubmittingLocation(),
      );
    }
  }
}
