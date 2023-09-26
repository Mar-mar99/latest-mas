// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import 'package:masbar/features/edit_profile/presentation/screens/edit_company_info_screen.dart';

import '../../../../../core/ui/widgets/app_text.dart';
import '../../../auth/accounts/domain/entities/user_entity.dart';
import '../../../edit_password/presentation/screens/edit_password_screen.dart';
import '../../../user_emirate/domain/entities/uae_state_entity.dart';
import '../widgets/edit_item.dart';
import '../widgets/user_avatar.dart';
import 'edit_phone_screen.dart';
import 'edit_state_screen.dart';
import 'edit_user_name_screen.dart';

class ProfileEditInfoScreen extends StatelessWidget {
  final TypeAuth typeAuth;
  final List<UAEStateEntity> states;
  const ProfileEditInfoScreen({
    Key? key,
    required this.typeAuth,
    required this.states,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = context.read<AuthRepo>().getUserData();

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.center,
                child: const UserAvatar(),
              ),
              const SizedBox(
                height: 40,
              ),
              typeAuth == TypeAuth.company
                  ? _buildCompanyInfo(context, userData)
                  : _buildEditName(context, userData!),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                height: 1,
                color: Color(0xffEEEEEE),
              ),
              const SizedBox(
                height: 20,
              ),
              _buildState(context, userData!, states),
              const SizedBox(
                height: 20,
              ),
              if ((userData.loginBy != null &&
                      userData.loginBy == UserLoginType.manual) ||
                  userData.loginBy == null) ...[
                _buildPhone(context, userData),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  height: 1,
                  color: Color(0xffEEEEEE),
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildEditPassword(context),
              ]
            ],
          ),
        ),
      ),
    );
  }

  InkWell _buildCompanyInfo(BuildContext context, UserEntity? userData) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, EditCompanyInfoScreen.routeName);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                AppLocalizations.of(context)!.yourInformation,
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 5,
              ),
              AppText(
                '${userData!.firstName} ${userData.lastName}',
                color: Colors.grey,
                fontSize: 15,
              ),
              const SizedBox(
                height: 5,
              ),
              AppText(
                '${userData.address}',
                color: Colors.grey,
                fontSize: 15,
              ),
              const SizedBox(
                height: 5,
              ),
              AppText(
                userData.local! == 0
                    ? AppLocalizations.of(context)?.citizen ?? ""
                    : AppLocalizations.of(context)?.noncitizen ?? "",
                color: Colors.grey,
                fontSize: 15,
              ),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, EditCompanyInfoScreen.routeName);
            },
            child: Icon(
              EvaIcons.editOutline,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEditPassword(BuildContext context) {
    return EditItem(
        label: AppLocalizations.of(context)!.password,
        value: '********',
        onTapHandler: () {
          Navigator.pushNamed(context, EditPasswordScreen.routeName);
        });
  }

  Widget _buildPhone(BuildContext context, UserEntity user) {
    return EditItem(
        label: AppLocalizations.of(context)!.phoneNumber,
        value: '${user.mobile}',
        onTapHandler: () {
          Navigator.pushNamed(context, EditPhoneScreen.routeName);
        });
  }

  Widget _buildState(
      BuildContext context, UserEntity userData, List<UAEStateEntity> states) {
    late UAEStateEntity stateEmirate;

    if (states.isNotEmpty) {
      stateEmirate =
          states.firstWhere((element) => element.id == userData.stateId);
    }

    return EditItem(
        label: AppLocalizations.of(context)!.emirate,
        value: stateEmirate.state,
        onTapHandler: () {
          Navigator.pushNamed(context, EditStateScreen.routeName, arguments: {
            'states': states,
            "selectedState": stateEmirate,
          });
        });
  }

  Widget _buildEditName(BuildContext context, UserEntity userData) {
    return EditItem(
        label: AppLocalizations.of(context)!.name,
        value: '${userData.firstName} ${userData.lastName}',
        onTapHandler: () {
          Navigator.pushNamed(context, EditUserNameScreen.routeName);
        });
  }
}
