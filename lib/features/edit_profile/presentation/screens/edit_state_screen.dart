// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/features/edit_profile/presentation/screens/profile_info_screen.dart';

import '../../../../core/api_service/network_service_http.dart';
import '../../../../../core/network/check_internet.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_drop_down.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/utils/helpers/form_submission_state.dart';
import '../../../../../core/utils/helpers/toast_utils.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../core/utils/helpers/helpers.dart';
import '../../../auth/accounts/data/data sources/user_remote_data_source.dart';
import '../../../auth/accounts/data/repositories/user_repo_impl.dart';
import '../../../auth/accounts/domain/repositories/auth_repo.dart';
import '../../../user_emirate/domain/entities/uae_state_entity.dart';
import '../../data/data_source/update_profile_data_source.dart';
import '../../data/repositories/update_profile_repo_impl.dart';
import '../../domain/use_cases/update_company_profile_use_case.dart';
import '../../domain/use_cases/update_provider_profile_use_case.dart';
import '../../domain/use_cases/update_user_profile_use_case.dart';
import '../bloc/edit_state_bloc.dart';

class EditStateScreen extends StatelessWidget {
  final List<UAEStateEntity> states;
  final UAEStateEntity selectedState;
  static const routeName = 'edit_state_screen';
  const EditStateScreen({
    Key? key,
    required this.states,
    required this.selectedState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(context),
      child: Builder(builder: (context) {
        return BlocListener<EditStateBloc, EditStateState>(
          listener: (context, state) {
            _buildListener(state, context);
          },
          child: Scaffold(
            appBar:
                AppBar(title: Text(AppLocalizations.of(context)!.edit_emirate)),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLabel(context),
                    _buildStateDropDown(context, states),
                    const SizedBox(
                      height: 16,
                    ),
                    _buildAppBtn(context),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAppBtn(BuildContext context) {
    return BlocBuilder<EditStateBloc, EditStateState>(
      builder: (context, state) {
        var loading = false;
        if (state.formSubmissionState is FormSubmittingState) {
          loading = true;
        }
        return AppButton(
          isDisabled: state.state==0,
          title: AppLocalizations.of(context)?.save ?? "",
          isLoading: loading,
          onTap: () async {
            switch (Helpers.getUserTypeEnum(
                context.read<AuthRepo>().getUserData()!.type!)) {
              case TypeAuth.user:
                BlocProvider.of<EditStateBloc>(context).add(
                  StateUserSubmitEvent(
                    firstName:
                        context.read<AuthRepo>().getUserData()!.firstName!,
                    lastName: context.read<AuthRepo>().getUserData()!.lastName!,
                  ),
                );
                break;
              case TypeAuth.company:
                BlocProvider.of<EditStateBloc>(context).add(
                  StateCompanySubmitEvent(
                    firstName:
                        context.read<AuthRepo>().getUserData()!.firstName!,
                    address: context.read<AuthRepo>().getUserData()!.address!,
                    local: context.read<AuthRepo>().getUserData()!.local!,
                  ),
                );
                break;
              case TypeAuth.provider:
                BlocProvider.of<EditStateBloc>(context).add(
                  StateProviderSubmitEvent(
                    firstName:
                        context.read<AuthRepo>().getUserData()!.firstName!,
                    lastName: context.read<AuthRepo>().getUserData()!.lastName!,
                  ),
                );
                break;
            }

          },
        );
      },
    );
  }

  void _buildListener(EditStateState state, BuildContext context) {
    if (state.formSubmissionState is FormNoInternetState) {
      ToastUtils.showErrorToastMessage('No internet connection');
    } else if (state.formSubmissionState is FormNetworkErrorState) {
      ToastUtils.showErrorToastMessage(
          (state.formSubmissionState as FormNetworkErrorState).message);
    } else if (state.formSubmissionState is FormSuccesfulState) {
      ToastUtils.showSusToastMessage(
          'The Emirate has been changed Successfully');
          Navigator.pop(context);
           Navigator.pop(context);
     Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return  ProfileInfoScreen(typeAuth:
            Helpers.getUserTypeEnum(context.read<AuthRepo>().getUserData()!.type!)
            );
          },
        ),
      );
    }
  }

  EditStateBloc _getBloc(BuildContext context) {
    return EditStateBloc(
      updateProviderProfileUseCase: UpdateProviderProfileUseCase(
        authRepo: context.read<AuthRepo>(),
        userRepo: UserRepoImpl(

          userRemoteDataSource: UserRemoteDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
        updateProfileRepo: UpdateProfileRepoImpl(
          updateProfileDataSource: UpdateProfileDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
          networkInfo: NetworkInfoImpl(
            internetConnectionChecker: InternetConnectionChecker(),
          ),
        ),
      ),
      updateCompanyProfileUseCase: UpdateCompanyProfileUseCase(
        authRepo: context.read<AuthRepo>(),
        userRepo: UserRepoImpl(

          userRemoteDataSource: UserRemoteDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
        updateProfileRepo: UpdateProfileRepoImpl(
          updateProfileDataSource: UpdateProfileDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
          networkInfo: NetworkInfoImpl(
            internetConnectionChecker: InternetConnectionChecker(),
          ),
        ),
      ),
      updateUserProfileUseCase: UpdateUserProfileUseCase(
        authRepo: context.read<AuthRepo>(),
        userRepo: UserRepoImpl(

          userRemoteDataSource: UserRemoteDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
        updateProfileRepo: UpdateProfileRepoImpl(
          updateProfileDataSource: UpdateProfileDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
          networkInfo: NetworkInfoImpl(
            internetConnectionChecker: InternetConnectionChecker(),
          ),
        ),
      ),
    );
  }

  AppText _buildLabel(BuildContext context) {
    return AppText(
      AppLocalizations.of(context)?.emirate ?? "",
      color: Colors.black,
      fontSize: 20,
      textAlign: TextAlign.center,
      fontWeight: FontWeight.bold,
    );
  }

  AppDropDown<UAEStateEntity> _buildStateDropDown(
    BuildContext context,
    List<UAEStateEntity> states,
  ) {
    return AppDropDown<UAEStateEntity>(
      hintText: AppLocalizations.of(context)!.choose_your_emirate,
      items: states.map((e) => _buildDropMenuItem(context, e)).toList(),
      onChanged: (value) {
        BlocProvider.of<EditStateBloc>(context)
            .add(StateChangedEvent(state: value.id));
      },
      initSelectedValue: selectedState,
    );
  }

  DropdownMenuItem<UAEStateEntity> _buildDropMenuItem(
      BuildContext context, UAEStateEntity e) {
    return DropdownMenuItem<UAEStateEntity>(
      value: e,
      child: Text(
        e.state,
      ),
    );
  }
}
