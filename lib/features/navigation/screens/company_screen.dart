import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:masbar/core/utils/extensions/navigation_extension.dart';

import '../../../core/utils/enums/enums.dart';
import '../../../core/utils/enums/navigation_enums.dart';
import '../../company/account/presentation/account/screens/account_company_screen.dart';
import '../../company/summary_and_earnings/presentation/summary/screens/company_summary_screen.dart';
import '../cubit/company_navigation_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/features/notification/presentation/screens/notification_screen.dart';

class CompanyScreen extends StatelessWidget {
  const CompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: _buildTitle(context),
        ),
        bottomNavigationBar: _buildBottomBar(),
        body: SafeArea(child: _buildBody()),
      );
    });
  }

  Widget _buildTitle(BuildContext context) {
    return BlocBuilder<CompanyNavigationCubit, CompanyNavigationState>(
        builder: (context, state) {
      return Text(state.navigationCompany.getText(context));
    });
  }

  Widget _buildBottomBar() {
    return BlocBuilder<CompanyNavigationCubit, CompanyNavigationState>(
        builder: (context, state) {
      return BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: state.index,
        onTap: (value) {
          BlocProvider.of<CompanyNavigationCubit>(context)
              .getItem(NavigationCompany.values[value]);
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Boxicons.bx_home_circle),
            label: AppLocalizations.of(context)?.home ?? "",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Boxicons.bx_bell),
            label: AppLocalizations.of(context)?.notifications ?? "",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Boxicons.bx_user),
            label: AppLocalizations.of(context)?.account ?? "",
          ),
        ],
      );
    });
  }

  Widget _buildBody() {
    return BlocBuilder<CompanyNavigationCubit, CompanyNavigationState>(
      builder: (context, state) {
        if (state.navigationCompany == NavigationCompany.summary) {
          return CompanySummaryScreen(showAppbar: false,);
        } else if (state.navigationCompany == NavigationCompany.notification) {
          return const NotificationScreen(
            typeAuth: TypeAuth.company,
          );
        } else if (state.navigationCompany == NavigationCompany.account) {
          return const AccountCompanyScreen();
        } else {
          return Container();
        }
      },
    );
  }
}
