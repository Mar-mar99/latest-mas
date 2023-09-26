import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_wrapper/app_wrapper.dart';
import '../auth/accounts/presentation/bloc/authentication_bloc.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = 'splash_scrren';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var duration = const Duration(seconds: 8);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
   if(mounted) BlocProvider.of<AuthenticationBloc>(context).add(AppStarted());
    if(mounted)   Navigator.of(context).pushReplacementNamed(AppWrapper.routeName);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/splash.gif',
          gaplessPlayback: true,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
