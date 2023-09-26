import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/presentation/screens/provider_signup_screen.dart';
import 'package:masbar/features/auth/accounts/presentation/screens/user_signup_screen.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/app_button.dart';

import 'package:masbar/features/auth/accounts/presentation/screens/company_signup_screen.dart';

class SelectSignupTypeScreen extends StatefulWidget {
  static const routeName = 'select_signup_type_screen';
  const SelectSignupTypeScreen({super.key});

  @override
  State<SelectSignupTypeScreen> createState() => _SelectSignupTypeScreenState();
}

class _SelectSignupTypeScreenState extends State<SelectSignupTypeScreen> {
  bool isPatient = true;
  TypeAuth type = TypeAuth.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Column(
            children: [
              const SizedBox(height: 70),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    12,
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      AppText(
                        AppLocalizations.of(context)?.selectUserType ?? "",
                        bold: true,
                      ),
                      const SizedBox(height: 40),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        height: 50,
                        child: Row(
                          children: [
                            _buildUserBtn(context),
                            const SizedBox(
                              width: 5,
                            ),
                            _buildCompanyBtn(context),
                            const SizedBox(
                              width: 5,
                            ),
                            _buildProviderBtn(context),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildLogo(),
                      _buildBtn(context),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: AppButton(
        title: AppLocalizations.of(context)?.next ?? "",
        isLoading: false,
        onTap: () {
          navigateToSignUp();
        },
      ),
    );
  }

  navigateToSignUp() {
    switch (type) {
      case TypeAuth.user:
        Navigator.pushNamed(context, UserSignupScreen.routeName);
        break;
      case TypeAuth.company:
      Navigator.pushNamed(context, CompanySignupScreen.routeName);
        break;
      case TypeAuth.provider:
      Navigator.pushNamed(context, ProviderSignupScreen.routeName);
        break;
    }
  }

  SizedBox _buildLogo() {
    return SizedBox(
      width: 287.7,
      height: 287.7,
      child: ClipRRect(
        child: Image.asset(type == TypeAuth.user
            ? 'assets/images/logo.jpg'
            : type == TypeAuth.company
                ? 'assets/images/logo.jpg'
                : 'assets/images/logo.jpg'),
      ),
    );
  }

  Expanded _buildProviderBtn(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            type = TypeAuth.provider;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: type == TypeAuth.provider
                ? Border.all(color: Theme.of(context).primaryColor, width: 1)
                : null,
            color: type == TypeAuth.provider
                ? Theme.of(context).colorScheme.background
                : Theme.of(context).disabledColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                AppLocalizations.of(context)?.provider ?? "",
                fontSize: 14,
                color: type == TypeAuth.provider
                    ? Theme.of(context).primaryColor
                    : Colors.black,
                bold: type == TypeAuth.provider,
              ),
              if (type == TypeAuth.provider) const SizedBox(width: 5),
              if (type == TypeAuth.provider)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildCompanyBtn(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            type = TypeAuth.company;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: (type == TypeAuth.company)
                ? Border.all(color: Theme.of(context).primaryColor, width: 1)
                : null,
            color: (type == TypeAuth.company)
                ? Theme.of(context).colorScheme.background
                : Theme.of(context).disabledColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                AppLocalizations.of(context)?.company ?? "",
                fontSize: 14,
                color: type == TypeAuth.company
                    ? Theme.of(context).primaryColor
                    : Colors.black,
                bold: type == TypeAuth.company,
              ),
              if (type == TypeAuth.company) const SizedBox(width: 5),
              if (type == TypeAuth.company)
                Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildUserBtn(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            type = TypeAuth.user;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: type == TypeAuth.user
                ? Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  )
                : null,
            color: type == TypeAuth.user
                ? Theme.of(context).colorScheme.background
                : Theme.of(context).disabledColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                AppLocalizations.of(context)?.user ?? "",
                fontSize: 14,
                color: type == TypeAuth.user
                    ? Theme.of(context).primaryColor
                    : Colors.black,
                bold: type == TypeAuth.user,
              ),
              if (type == TypeAuth.user) const SizedBox(width: 5),
              if (type == TypeAuth.user)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
