import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/network/check_internet.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/utils/helpers/snackbar.dart';
import '../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/utils/helpers/toast_utils.dart';
import '../../data/data sources/forget_password_data_source.dart';
import '../../data/repositories/forget_password_repo_impl.dart';
import '../../domain/use cases/submit_new_password_usecase.dart';
import '../bloc/submit_new_password_bloc.dart';
import 'package:http/http.dart';
import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = 'change_password_screen';
  final int id;
  final TypeAuth typeAuth;
  ChangePasswordScreen({super.key, required this.id, required this.typeAuth});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController newPasswordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController controller = TextEditingController();

  bool isLoading = false;

  final formKeyPassword = GlobalKey<FormState>();

  String code = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: _buildAppbar(context),
          body: BlocListener<SubmitNewPasswordBloc, SubmitNewPasswordState>(
            listener: (context, state) {
              _buildListener(state, context);
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.emailHasBeenSent ?? "",
                      style: const TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      AppLocalizations.of(context)?.otpMessage ?? "",
                      style: const TextStyle(
                        color: Color(0xffA8A8A8),
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      AppLocalizations.of(context)?.otpMessage2 ?? "",
                      style: TextStyle(
                        color: Color(0xffA8A8A8),
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,

                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        inactiveColor: Theme.of(context).dividerColor,
                        activeColor: Theme.of(context).dividerColor,
                        selectedColor: Theme.of(context).primaryColor,
                        inactiveFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      animationDuration: const Duration(milliseconds: 300),
                      // backgroundColor: Colors.white,
                      enableActiveFill: true,
                      controller: controller,
                      onCompleted: (v) {
                        print("Completed");
                      },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          code = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: formKeyPassword,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              AppText(
                                AppLocalizations.of(context)?.newPassword ?? "",
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          _buildPasswordField(context),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              AppText(
                                AppLocalizations.of(context)?.confirmPassword ??
                                    "",
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          _buildConfirmPassword(context),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildBtn(context),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _buildListener(SubmitNewPasswordState state, BuildContext context) {
    if (state is SubmitNewPasswordStateOfflineState) {
      showSnackbar(context, 'No internet connection');
    } else if (state is SubmitNewPasswordStateErrorState) {
      ToastUtils.showErrorToastMessage('${state.message} \n Try Again');
    } else if (state is DoneSubmitNewPasswordState) {
      ToastUtils.showSusToastMessage(
          'The password has been updated successfully');
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.routeName, (route) => false);
    }
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: AppText(AppLocalizations.of(context)?.forgetPasswordAppBar ?? "",
          style: const TextStyle(color: Colors.white)),
      elevation: 0,
    );
  }

  Widget _buildBtn(BuildContext context) {
    return BlocBuilder<SubmitNewPasswordBloc, SubmitNewPasswordState>(
      builder: (context, state) {
        print('the state is $state');
        var isLoading = false;
        if (state is LoadingSubmitNewPasswordState) {
          isLoading = true;
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 250,
            child: AppButton(
              isLoading: isLoading,
              title: AppLocalizations.of(context)?.changePassword ?? "",
              onTap: () {
                if (formKeyPassword.currentState!.validate()) {
                  BlocProvider.of<SubmitNewPasswordBloc>(context).add(
                    SubmitDataEvent(
                      widget.typeAuth,
                      id: widget.id,
                      code: code,
                      password: newPasswordController.text,
                      confirmPassword: confirmPasswordController.text,
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  AppTextField _buildConfirmPassword(BuildContext context) {
    return AppTextField(
      controller: confirmPasswordController,
      hintText: '********',
      suffixIconColor: Colors.grey,
      type: 'password',
      validator: (value) {
        if (value!.isEmpty) {
          return AppLocalizations.of(context)?.errorPassword1 ?? "";
        } else if (value.length < 8) {
          return AppLocalizations.of(context)?.errorPassword2 ?? "";
        } else if (newPasswordController.text !=
            confirmPasswordController.text) {
          return AppLocalizations.of(context)?.errorPassword5 ?? "";
        } else if (!value.toString().contains(RegExp(r'[0-9]'))) {
          return AppLocalizations.of(context)?.errorPassword3 ?? "";
        } else if (!value
            .toString()
            .contains(RegExp(r'[!@#<>?":_`~;[\]\/¬£$%^|=+).,(*&^%-]'))) {
          return AppLocalizations.of(context)?.errorPassword4 ?? "";
        }
        return null;
      },
    );
  }

  AppTextField _buildPasswordField(BuildContext context) {
    return AppTextField(
      controller: newPasswordController,
      hintText: '********',
      suffixIconColor: Colors.grey,
      type: 'password',
      validator: (value) {
        if (value!.isEmpty) {
          return AppLocalizations.of(context)?.errorPassword1 ?? "";
        } else if (value.length < 8) {
          return AppLocalizations.of(context)?.errorPassword2 ?? "";
        } else if (newPasswordController.text !=
            confirmPasswordController.text) {
          return AppLocalizations.of(context)?.errorPassword5 ?? "";
        } else if (!value.toString().contains(RegExp(r'[0-9]'))) {
          return AppLocalizations.of(context)?.errorPassword3 ?? "";
        } else if (!value
            .toString()
            .contains(RegExp(r'[!@#<>?":_`~;[\]\/¬£$%^|=+).,(*&^%-]'))) {
          return AppLocalizations.of(context)?.errorPassword4 ?? "";
        }
        return null;
      },
    );
  }

  SubmitNewPasswordBloc _getBloc() {
    return SubmitNewPasswordBloc(
      submitNewPasswordUseCase: SubmitNewPasswordUseCase(
        forgetPasswordRepo: ForgetPasswordRepoImpl(
          forgetPasswordDataSource:
              ForgetPasswordDataSourceWithHttp(client: NetworkServiceHttp()),
        ),
      ),
    );
  }
}
