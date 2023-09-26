import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/core/network/check_internet.dart';
import 'package:masbar/core/utils/helpers/form_submission_state.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';

import '../../../../core/ui/widgets/app_button.dart';
import '../../../../core/ui/widgets/app_text.dart';
import '../../../../core/ui/widgets/app_textfield.dart';
import '../../../../core/utils/helpers/helpers.dart';
import '../../data/data_source/edit_password_data_source.dart';
import '../../data/repositories/edit_password_repo_impl.dart';
import '../../domain/use_cases/edit_password_use_case.dart';
import '../bloc/edit_password_bloc.dart';

class EditPasswordScreen extends StatelessWidget {
 static const  routeName ='edit_password_screen';
  EditPasswordScreen({super.key});
  final formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController reNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.editPassword,
          ),
        ),
        body: Builder(builder: (context) {
          return BlocListener<EditPasswordBloc, EditPasswordState>(
            listener: (context, state) {
              _buildListener(state, context);
            },
            child: SingleChildScrollView(
              child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        _buildLabel(
                          context,
                          AppLocalizations.of(context)?.currentPassword ?? "",
                        ),
                        _buildCurrentPasswordField(context),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildLabel(
                          context,
                          AppLocalizations.of(context)?.newPassword ?? "",
                        ),
                        _buildNewPasswordField(context),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildLabel(
                          context,
                          AppLocalizations.of(context)?.retypePassword ?? "",
                        ),
                        _buildConfirmPassword(context),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildSubmitBtn(context),
                      ],
                    ),
                  )),
            ),
          );
        }),

      ),
    );
  }

  void _buildListener(EditPasswordState state, BuildContext context) {
    if (state.formSubmissionState is FormNoInternetState) {
      ToastUtils.showErrorToastMessage('No internet connection');
    } else if (state.formSubmissionState is FormNetworkErrorState) {
      ToastUtils.showErrorToastMessage(
          (state.formSubmissionState as FormNetworkErrorState).message);
    } else if (state.formSubmissionState is FormSuccesfulState) {
      ToastUtils.showSusToastMessage('Password has been changed Successfully');
      Navigator.pop(context);
    }
  }

  EditPasswordBloc _getBloc() {
    return EditPasswordBloc(
      editPasswordUseCase: EditPasswordUseCase(
        editPasswordRepo: EditPasswordRepoImpl(
          editPasswordDataSource:
              EditPasswordDataSourceWithHttp(client: NetworkServiceHttp()),
          networkInfo: NetworkInfoImpl(
            internetConnectionChecker: InternetConnectionChecker(),
          ),
        ),
      ),
    );
  }

  Padding _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AppText(
        text,
        color: Colors.black,
        fontSize: 18,
        textAlign: TextAlign.center,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSubmitBtn(BuildContext context) {
    return  Center(
        child: BlocBuilder<EditPasswordBloc, EditPasswordState>(
          builder: (context, state) {
            var loading = false;
            if (state.formSubmissionState is FormSubmittingState) {
              loading = true;
            }
            return AppButton(
              isLoading: loading,
              title: AppLocalizations.of(context)?.save ?? "",
              onTap: () async {
                BlocProvider.of<EditPasswordBloc>(context).add(
                  SubmitEditPasswordEvent(
                    typeAuth: Helpers.getUserTypeEnum(
                      context.read<AuthRepo>().getUserData()!.type!,
                    ),
                  ),
                );
              },
            );
          },
        ),

    );
  }

  AppTextField _buildConfirmPassword(BuildContext context) {
    return AppTextField(
      controller: reNewPasswordController,
      type: "password",
      hintText: AppLocalizations.of(context)?.enterPassword ?? "",
          textInputAction: TextInputAction.done,
      onChanged: (value) {
        BlocProvider.of<EditPasswordBloc>(context)
            .add(ConfirmPasswordChangedEvent(password: value));
      },
      validator: (value) {
        if (value!.isEmpty) {
          return AppLocalizations.of(context)?.errorPassword1 ?? "";
        } else if (value.length < 8) {
          return AppLocalizations.of(context)?.errorPassword2 ?? "";
        } else if (!value.toString().contains(RegExp(r'[0-9]'))) {
          return AppLocalizations.of(context)?.errorPassword3 ?? "";
        } else if (!value
            .toString()
            .contains(RegExp(r'[!@#<>?":_`~;[\]\\/¬£$%^|=+).,(*&^%-]'))) {
          return AppLocalizations.of(context)?.errorPassword4 ?? "";
        } else if (newPasswordController.text != value) {
          return AppLocalizations.of(context)?.errorPassword5 ?? "";
        }
        return null;
      },
    );
  }

  AppTextField _buildNewPasswordField(BuildContext context) {
    return AppTextField(
      controller: newPasswordController,
      type: "password",
          textInputAction: TextInputAction.next,
      hintText: AppLocalizations.of(context)?.enterPassword ?? "",
      onChanged: (value) {
        BlocProvider.of<EditPasswordBloc>(context)
            .add(NewPasswordChangedEvent(password: value));
      },
      validator: (value) {
        if (value!.isEmpty) {
          return AppLocalizations.of(context)?.errorPassword1 ?? "";
        } else if (value.length < 8) {
          return AppLocalizations.of(context)?.errorPassword2 ?? "";
        } else if (!value.toString().contains(RegExp(r'[0-9]'))) {
          return AppLocalizations.of(context)?.errorPassword3 ?? "";
        } else if (!value
            .toString()
            .contains(RegExp(r'[!@#<>?":_`~;[\]\\/¬£$%^|=+).,(*&^%-]'))) {
          return AppLocalizations.of(context)?.errorPassword4 ?? "";
        }
        return null;
      },
    );
  }

  AppTextField _buildCurrentPasswordField(BuildContext context) {
    return AppTextField(
      type: "password",
      controller: currentPasswordController,
          textInputAction: TextInputAction.next,
      onChanged: (value) {
        BlocProvider.of<EditPasswordBloc>(context)
            .add(CurrentPasswordChangedEvent(password: value));
      },
      hintText: AppLocalizations.of(context)?.enterPassword ?? "",
      validator: (value) {
        if (value!.isEmpty) {
          return AppLocalizations.of(context)?.errorPassword1 ?? "";
        } else if (value.length < 8) {
          return AppLocalizations.of(context)?.errorPassword2 ?? "";
        } else if (!value.toString().contains(RegExp(r'[0-9]'))) {
          return AppLocalizations.of(context)?.errorPassword3 ?? "";
        } else if (!value
            .toString()
            .contains(RegExp(r'[!@#<>?":_`~;[\]\\/¬£$%^|=+).,(*&^%-]'))) {
          return AppLocalizations.of(context)?.errorPassword4 ?? "";
        }
        return null;
      },
    );
  }
}
