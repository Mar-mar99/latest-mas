import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/core/network/check_internet.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/core/utils/helpers/form_submission_state.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import 'package:masbar/features/edit_profile/presentation/screens/profile_info_screen.dart';

import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../core/utils/helpers/toast_utils.dart';
import '../../../../core/utils/helpers/helpers.dart';
import '../../../auth/accounts/data/data sources/user_remote_data_source.dart';
import '../../../auth/accounts/data/repositories/user_repo_impl.dart';
import '../../data/data_source/update_profile_data_source.dart';

import '../../data/repositories/update_profile_repo_impl.dart';
import '../../domain/use_cases/update_provider_profile_use_case.dart';
import '../../domain/use_cases/update_user_profile_use_case.dart';
import '../bloc/edit_name_bloc.dart';

class EditUserNameScreen extends StatelessWidget {
  static const routeName = 'edit_user_name_screen';
  EditUserNameScreen({super.key});
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    firstNameController.text=context.read<AuthRepo>().getUserData()!.firstName!;
   lastNameController.text=context.read<AuthRepo>().getUserData()!.lastName!;

    return BlocProvider(
      create: (context) => _getBloc(context),
      child: Builder(builder: (context) {
        return BlocListener<EditNameBloc, EditNameState>(
          listener: (context, state) {
            _buildListener(state, context);
          },
          child: Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.editName)),
            body: SingleChildScrollView(
              child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildLabel(context,
                            AppLocalizations.of(context)!.enterFirstName),
                        _buildFirstName(context),
                        const SizedBox(height: 16,)
,                        _buildLabel(
                            context, AppLocalizations.of(context)!.lastName),
                        _buildLastName(context),
                        const SizedBox(height: 24,),
                        _buildSubmitBtn(context),
                      ],
                    ),
                  )),
            ),

          ),
        );
      }),
    );
  }

  void _buildListener(EditNameState state, BuildContext context) {
    if (state is EditNameOfflineState) {
      ToastUtils.showErrorToastMessage('No internet connection');
    } else if (state is EditNameErrorState) {
      ToastUtils.showErrorToastMessage(
          (state ).message);
    } else if (state is DoneEditNameState) {
      ToastUtils.showSusToastMessage('Data has been changed Successfully');
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
      ); }
  }

  EditNameBloc _getBloc(BuildContext context) {
    return EditNameBloc(
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

  Widget _buildSubmitBtn(BuildContext context) {
    return  BlocBuilder<EditNameBloc, EditNameState>(
            builder: (context, state) {
              var loading = false;
              if (state is LoadingEditNameState) {
                loading = true;
              }
              return AppButton(
                title: AppLocalizations.of(context)?.save ?? "",
                isLoading: loading,
                onTap: () async {
                  if (Helpers.getUserTypeEnum(
                          context.read<AuthRepo>().getUserData()!.type!) ==
                      TypeAuth.user) {
                    BlocProvider.of<EditNameBloc>(context).add(
                      SubmitUserNameEvent(
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        state: context.read<AuthRepo>().getUserData()!.stateId!,
                      ),
                    );
                  } else if (Helpers.getUserTypeEnum(
                          context.read<AuthRepo>().getUserData()!.type!) ==
                      TypeAuth.provider) {
                    BlocProvider.of<EditNameBloc>(context).add(
                      SubmitProviderNameEvent(
                            firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        state: context.read<AuthRepo>().getUserData()!.stateId!,
                      ),
                    );
                  }
                },
              );
            },

    );
  }

  AppTextField _buildLastName(BuildContext context) {
    return AppTextField(
      controller: lastNameController,
      textInputAction: TextInputAction.done,
      hintText: AppLocalizations.of(context)?.enterLastName ?? "",
      validator: (val) {
        if (val.toString().isEmpty) {
          return AppLocalizations.of(context)?.lastNameError ?? "";
        }
        return null;
      },
    );
  }

  AppTextField _buildFirstName(BuildContext context) {
    return AppTextField(
      controller: firstNameController,
      textInputAction: TextInputAction.next,
       hintText: AppLocalizations.of(context)?.enterFirstName ?? "",

      validator: (val) {
        if (val.toString().isEmpty) {
          return AppLocalizations.of(context)?.firstNameError ?? "";
        }
        return null;
      },
    );
  }

  AppText _buildLabel(BuildContext context, String text) {
    return AppText(
      text,
      color: Colors.black,
      fontSize: 20,
      textAlign: TextAlign.center,
      fontWeight: FontWeight.bold,
    );
  }
}
