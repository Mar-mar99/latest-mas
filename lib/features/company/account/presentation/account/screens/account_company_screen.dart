import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/profile/delete_account_item.dart';
import '../../../../../../core/ui/widgets/profile/help_item.dart';
import '../../../../../../core/ui/widgets/profile/language_item.dart';
import '../../../../../../core/ui/widgets/profile/large_avatar.dart';
import '../../../../../../core/ui/widgets/profile/log_out_item.dart';
import '../../../../../../core/ui/widgets/profile/profile_item.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/utils/helpers/helpers.dart';
import '../../../../../auth/accounts/domain/repositories/auth_repo.dart';
import '../../../../../documents_company/presentation/screens/documents_screen.dart';
import '../../../../../edit_profile/presentation/screens/profile_info_screen.dart';
import '../../../../manage_promotion/presentation/screens/manage_promotion_screen.dart';
import '../../../../manage_providers/presentation/screens/manage_providers_screen.dart';
import '../../../../services_prices/presentation/screens/services_prices_screen.dart';
import '../../../../services_settings/presentation/screens/attributes_service_settings.dart';
import '../../../../services_settings/presentation/screens/services_settings_screen.dart';
import '../../../../summary_and_earnings/presentation/earnings/screens/company_earnings_screen.dart';
import '../../../../summary_and_earnings/presentation/summary/screens/company_summary_screen.dart';
import '../../../../user_activity/data/data_source/user_activity_data_source.dart';
import '../../../../user_activity/data/repositories/user_activity_repo_impl.dart';
import '../../../../user_activity/domain/use_cases/get_experts_activity_use_case.dart';
import '../../../../user_activity/presentation/user_activity/bloc/get_user_activity_bloc.dart';
import '../../../../user_activity/presentation/service_history/screen/company_service_history.dart';
import '../../../../user_activity/presentation/user_activity/screens/user_activity_screen.dart';
import '../../profile/presentation/screens/company_profile_screen.dart';

class AccountCompanyScreen extends StatelessWidget {
  const AccountCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getUserActivityBloc(),
      child: Builder(builder: (context) {
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
                      const SizedBox(
                        height: 20,
                      ),
                      ProfileItem(
                        icon: Icons.miscellaneous_services_sharp,
                        text: AppLocalizations.of(context)
                                ?.servicesSettingsLabel ??
                            "",
                        onTap: () {
                          Navigator.pushNamed(
                              context, ServicesSettingsScreen.routeName);
                        },
                      ),
                      ProfileItem(
                        icon: Boxicons.bx_money,
                        text:
                            AppLocalizations.of(context)?.servicesPricesLabel ??
                                "",
                        onTap: () {
                          Navigator.pushNamed(
                              context, ServicesPricesScreen.routeName);
                        },
                      ),
                      ProfileItem(
                        icon: Boxicons.bxs_user_account,
                        text:
                            AppLocalizations.of(context)?.manageProviders ?? "",
                        onTap: () {
                          Navigator.pushNamed(
                              context, ManageProvidersScreen.routeName);
                        },
                      ),
                        ProfileItem(
                        icon: Boxicons.bx_gift,
                        text:
                            'Manage Promotions',
                        onTap: () {
                          Navigator.pushNamed(
                              context, ManagePromotionScreen.routeName);
                        }
                      ),
                      ProfileItem(
                          icon: Boxicons.bx_bolt_circle,
                          text: AppLocalizations.of(context)?.serviceHistory ??
                              "",
                          onTap: () {
                            Navigator.pushNamed(
                                context, CompanyServiceHistory.routeName);
                          }),
                      ProfileItem(
                        icon: EvaIcons.starOutline,
                        text: AppLocalizations.of(context)?.earnings ?? "",
                        onTap: () {
                          Navigator.pushNamed(
                              context, CompanyEarningsScreen.routeName);
                        },
                      ),
                      ProfileItem(
                        icon: Boxicons.bx_history,
                        text: AppLocalizations.of(context)?.summary ?? "",
                        onTap: () {
                          Navigator.pushNamed(
                              context, CompanySummaryScreen.routeName);
                        },
                      ),
                      ProfileItem(
                        icon: Boxicons.bx_book,
                        text: AppLocalizations.of(context)?.documents ?? "",
                        onTap: () {
                          Navigator.pushNamed(
                              context, DocumentsScreen.routeName);
                        },
                      ),
                      ProfileItem(
                        icon: Boxicons.bxs_user_detail,
                        text: AppLocalizations.of(context)?.usersActivity ?? "",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => BlocProvider.value(
                                      value:
                                          BlocProvider.of<GetUserActivityBloc>(
                                              context),
                                      child: const UserActivityScreen(),
                                    )),
                          );
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
      }),
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
                      'typeAuth': TypeAuth.company,
                    });
                // Navigator.pushNamed(
                //   context,
                //   CompanyProfileScreen.routeName,
                // );
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

  GetUserActivityBloc _getUserActivityBloc() {
    return GetUserActivityBloc(
      getExpertsActivityUseCase: GetExpertsActivityUseCase(
        userActivityRepo: UserActivityRepoImpl(
          userActivityDataSource: UserActivityDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(GetProvidersActivityEvent());
  }
}
