import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/user/notification_settings/presentation/screens/user_notification_settings_screen.dart';
import 'package:masbar/features/user/wallet/presentation/screen/electronic_wallet_screen.dart';
import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/network/check_internet.dart';
import '../../../../../core/utils/helpers/helpers.dart';
import '../../../../app_wrapper/app_wrapper.dart';
import '../../../../auth/accounts/domain/repositories/auth_repo.dart';
import '../../../../auth/accounts/presentation/bloc/authentication_bloc.dart';
import '../../../../../core/ui/widgets/app_dialog.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/custom_item.dart';
import '../../../../../core/ui/dialogs/loading_dialog.dart';
import '../../../../../core/ui/widgets/profile/delete_account_item.dart';
import '../../../../../core/ui/widgets/profile/help_item.dart';
import '../../../../../core/ui/widgets/profile/language_item.dart';
import '../../../../../core/ui/widgets/profile/large_avatar.dart';
import '../../../../../core/ui/widgets/profile/log_out_item.dart';
import '../../../../../core/ui/widgets/profile/profile_item.dart';
import '../../../../../core/utils/helpers/toast_utils.dart';
import '../../../../delete_account/data/data_source/delete_account_data_source.dart';
import '../../../../delete_account/data/repositories/delete_account_repo_impl.dart';
import '../../../../delete_account/domain/use_cases/delete_account_use_case.dart';
import '../../../../delete_account/presentation/bloc/delete_account_bloc.dart';
import '../../../../delete_account/presentation/delete_account_listener.dart';
import '../../../../edit_profile/presentation/screens/profile_info_screen.dart';
import '../../../my_locations/presentation/screens/my_locations_screen.dart';
import '../../../payment_methods/presentation/screens/payment_methods_screen.dart';
import '../../../promo_code/presentation/screens/promo_code_screen.dart';
import '../../../service_record/presentation/screens/service_record_screen.dart';

class ProfileUserScreen extends StatelessWidget {
  const ProfileUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildUserInfo(context),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  ProfileItem(
                    icon: Icons.location_on,
                    text: AppLocalizations.of(context)?.my_locations ?? "",
                    onTap: () {
                      Navigator.pushNamed(context, MyLocationsScreen.routeName);
                    },
                  ),
                  ProfileItem(
                    icon: EvaIcons.creditCardOutline,
                    text:
                        AppLocalizations.of(context)?.paymentMethodsTitle ?? "",
                    onTap: () {
                      Navigator.pushNamed(
                          context, PaymentMethodsScreen.routeName);
                    },
                  ),
                  ProfileItem(
                    icon: FontAwesomeIcons.gift,
                    text: AppLocalizations.of(context)?.discountCoupons ?? "",
                    onTap: () {
                      Navigator.pushNamed(context, PromoCodeScreen.routeName);
                    },
                  ),
                  ProfileItem(
                    icon: FontAwesomeIcons.wallet,
                    text: AppLocalizations.of(context)?.electronicWallet ?? "",
                    onTap: () {
                      Navigator.pushNamed(
                          context, ElectronicWalletScreen.routeName);
                    },
                  ),
                  ProfileItem(
                    icon: Boxicons.bx_history,
                    text: AppLocalizations.of(context)?.serviceRecord ?? "",
                    onTap: () {
                      Navigator.pushNamed(
                          context, ServiceRecordScreen.routeName);
                    },
                  ),
                  ProfileItem(
                    icon: Icons.notifications,
                    text: "Notification Settings",
                    onTap: () {
                      Navigator.pushNamed(
                          context, UserNotificationSettingsScreen.routeName);
                    },
                  ),
                  const LanguageItem(),
                  const HelpItem(),
                  const DeleteAccountItem(),
                  const LogOutItem(),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Column _buildUserInfo(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, ProfileInfoScreen.routeName,
                    arguments: {
                      'typeAuth': TypeAuth.user,
                    });
              },
              child: Icon(
                EvaIcons.editOutline,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        LargeAvatar(
          url: Helpers.getImage(
            context.read<AuthRepo>().getUserData()!.picture,
          ),
          name: context.read<AuthRepo>().getUserData()!.firstName,
          disableProfileView: true,
        ),
        const SizedBox(
          height: 10,
        ),
        AppText(
          '${context.read<AuthRepo>().getUserData()!.firstName} ${context.read<AuthRepo>().getUserData()!.lastName}',
          color: Colors.black,
          bold: true,
        ),
        const SizedBox(
          height: 5,
        ),
        AppText(
          '${context.read<AuthRepo>().getUserData()!.email}',
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
