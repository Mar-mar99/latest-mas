import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import 'package:masbar/features/auth/accounts/presentation/bloc/authentication_bloc.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/ui/widgets/app_dialog.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/custom_item.dart';
import '../../../../../core/ui/widgets/profile/delete_account_item.dart';
import '../../../../../core/ui/widgets/profile/help_item.dart';
import '../../../../../core/ui/widgets/profile/language_item.dart';
import '../../../../../core/ui/widgets/profile/large_avatar.dart';
import '../../../../../core/ui/widgets/profile/log_out_item.dart';
import '../../../../../core/ui/widgets/profile/profile_item.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/utils/helpers/helpers.dart';
import '../../../../edit_profile/presentation/screens/profile_info_screen.dart';
import '../../../earning_summary/presentation/earnings/screens/earning_provider_screen.dart';
import '../../../earning_summary/presentation/summary/screens/summary_provider_screen.dart';
import '../../../notification_settings/presentation/screens/provider_notification_settings_screen.dart';
import '../../../review/presentation/screens/review_screen.dart';
import '../../../service_records/presentation/screens/service_record_provider_screen.dart';
import '../../../review/data/data_source/review_data_source.dart';
import '../../../review/data/repositories/review_repo_impl.dart';
import '../../../review/domain/use_cases/get_reviews_use_case.dart';
import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/features/provider/review/presentation/bloc/get_reviews_bloc.dart';

class ProfileProviderScreen extends StatelessWidget {
  const ProfileProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(),
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
                        icon: Boxicons.bx_edit,
                        text: AppLocalizations.of(context)?.editProfile ?? "",
                        onTap: () {
                          Navigator.pushNamed(
                              context, ProfileInfoScreen.routeName,
                              arguments: {
                                'typeAuth': TypeAuth.provider,
                              });
                        },
                      ),
                      ProfileItem(
                        icon: Boxicons.bx_star,
                        text: AppLocalizations.of(context)?.review ?? "",
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (c) {
                              return BlocProvider.value(
                                  value: context.read<GetReviewsBloc>(),
                                  child: ReviewScreen());
                            },
                          ));
                          // Navigator.pushNamed(context, ReviewScreen.routeName);
                        },
                      ),
                      ProfileItem(
                        icon: Boxicons.bx_history,
                        text: AppLocalizations.of(context)?.serviceRecord ?? "",
                        onTap: () {
                          Navigator.pushNamed(
                              context, ServiceRecordProviderScreen.routeName);
                        },
                      ),
                      ProfileItem(
                        icon: Icons.monetization_on_outlined,
                        text: AppLocalizations.of(context)?.earningLabel ?? "",
                        onTap: () {
                          Navigator.pushNamed(
                              context, EarningProviderScreen.routeName);
                        },
                      ),
                      ProfileItem(
                        icon: Boxicons.bx_history,
                        text: AppLocalizations.of(context)?.summary ?? "",
                        onTap: () {
                          Navigator.pushNamed(
                              context, SummaryProviderScreen.routeName);
                        },
                      ),
                      ProfileItem(
                        icon: Icons.notifications,
                        text: "Notification Settings",
                        onTap: () {
                          Navigator.pushNamed(context,
                              ProviderNotificationSettingsScreen.routeName);
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

  GetReviewsBloc _getBloc() {
    return GetReviewsBloc(
      getReviewUseCase: GetReviewUseCase(
        reviewRepo: ReviewRepoImpl(
          reviewDataSource: ReviewDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(GetProviderReviewsEvent());
  }
}
