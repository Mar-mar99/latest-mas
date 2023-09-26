// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../auth/accounts/data/data sources/user_remote_data_source.dart';
import '../../../../../../auth/accounts/data/repositories/user_repo_impl.dart';
import '../../../../../../auth/accounts/domain/entities/user_entity.dart';
import '../../../../../../auth/accounts/domain/repositories/auth_repo.dart';
import '../../../../../../edit_password/presentation/screens/edit_password_screen.dart';
import '../../../../../../edit_profile/presentation/screens/edit_company_info_screen.dart';
import '../../../../../../edit_profile/presentation/screens/edit_phone_screen.dart';
import '../../../../../../edit_profile/presentation/screens/edit_state_screen.dart';
import '../../../../../../edit_profile/presentation/screens/edit_user_name_screen.dart';
import '../../../../../../edit_profile/presentation/widgets/edit_item.dart';
import '../../../../../../edit_profile/presentation/widgets/user_avatar.dart';
import '../../../../../../user_emirate/domain/entities/uae_state_entity.dart';
import '../../data/date_source/company_profile_data_source.dart';
import '../../data/repositories/company_profile_repo_impl.dart';
import '../../domain/use_cases/update_address_use_case.dart';
import '../company_address/bloc/update_address_bloc.dart';
import '../company_address/dialogs/address_dialog.dart';
import '../company_emirates/screens/company_emirates_screen.dart';
import 'company_location_screen.dart';
import 'company_working_area.dart';

class CompanyProfileScreen extends StatelessWidget {
  final List<UAEStateEntity> states;
  static const routeName = 'company_profile_screen';
  const CompanyProfileScreen({
    Key? key,
    required this.states,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = context.read<AuthRepo>().getUserData();

    return BlocProvider(
      create: (context) => _getUpdateAddressBloc(context),
      child: Builder(builder: (context) {
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
                  _buildCompanyInfo(context, userData),
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
                  _buildAddress(context, userData!),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildState(context, userData, states),
                  const SizedBox(
                    height: 20,
                  ),
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
                  const SizedBox(
                    height: 20,
                  ),
                  _builCompanyEmirates(context, userData),
                  const SizedBox(
                    height: 20,
                  ),
                  _builCompanyLocation(context, userData),
                  const SizedBox(
                    height: 20,
                  ),
                  _builCompanyWorkingAreas(context, userData),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  UpdateAddressBloc _getUpdateAddressBloc(BuildContext context) {
    return UpdateAddressBloc(
      updateAddressUseCase: UpdateAddressUseCase(
        companyProfileRepo: CompanyProfileRepoImpl(
          companyProfileDataSource: CompanyProfileDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
        authRepo: context.read<AuthRepo>(),
        userRepo: UserRepoImpl(
          userRemoteDataSource: UserRemoteDataSourceWithHttp(
            client: NetworkServiceHttp(),
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
                height: 2,
              ),
              AppText(
                '${userData!.firstName} ${userData.lastName}',
                color: Colors.grey,
                fontSize: 15,
              ),
              const SizedBox(
                height: 2,
              ),
              AppText(
                '${userData.address}',
                color: Colors.grey,
                fontSize: 15,
              ),
              const SizedBox(
                height: 2,
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

  Widget _buildAddress(
    BuildContext context,
    UserEntity userData,
  ) {
    return EditItem(
        label: AppLocalizations.of(context)!.address,
        value: userData.address!,
        onTapHandler: () {
          showDialog(
            context: context,
            builder: (dialogContext) {
              return BlocProvider.value(
               value: context.read<UpdateAddressBloc>(),
                child: AddressDialog(
                  address: userData.address!,
                ),
              );
            },
          );
        });
  }

  Widget _builCompanyEmirates(
    BuildContext context,
    UserEntity userData,
  ) {
    return EditItem(
        label: AppLocalizations.of(context)!.company_emirates,
        showValue: false,
        value: '',
        onTapHandler: () {
          Navigator.pushNamed(context, CompanyEmiratesScreen.routeName);
        });
  }

  Widget _builCompanyLocation(
    BuildContext context,
    UserEntity userData,
  ) {
    return EditItem(
        label: AppLocalizations.of(context)!.companyLocation,
        showValue: false,
        value: '',
        onTapHandler: () {
          Navigator.pushNamed(context, CompanyLocationScreen.routeName);
        });
  }

  Widget _builCompanyWorkingAreas(
    BuildContext context,
    UserEntity userData,
  ) {
    return EditItem(
        label: AppLocalizations.of(context)!.companyWorkingAreas,
        showValue: false,
        value: '',
        onTapHandler: () {
          Navigator.pushNamed(context, CompanyWorkingAreaScreen.routeName);
        });
  }
}
