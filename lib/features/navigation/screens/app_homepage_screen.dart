// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:masbar/features/navigation/screens/provider_screen.dart';
import 'package:masbar/features/navigation/screens/user_screen.dart';


import '../../../core/utils/enums/enums.dart';
import 'company_screen.dart';


class AppHomepageScreen extends StatelessWidget {
  final TypeAuth typeAuth;
  const AppHomepageScreen({
    Key? key,
    required this.typeAuth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getSideScreen(typeAuth);
  }

  Widget getSideScreen(TypeAuth typeAuth) {
    switch (typeAuth) {
      case TypeAuth.user:
        return const UserScreen();
      case TypeAuth.company:
        return const CompanyScreen();
      case TypeAuth.provider:
        return const ProviderScreen();
    }
  }
}
