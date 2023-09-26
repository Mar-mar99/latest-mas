import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import 'package:masbar/features/auth/accounts/presentation/bloc/authentication_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/network/check_internet.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/utils/helpers/snackbar.dart';
import '../../../../app_wrapper/app_wrapper.dart';
import '../../data/data sources/verify_account_data_source.dart';
import '../../data/repositories/verify_account_repo_impl.dart';
import '../../domain/use cases/resend_code_usecase.dart';
import '../../domain/use cases/verify_account_usecase.dart';
import '../bloc/verify_account_bloc.dart';
import 'package:masbar/main.dart';
class OTPScreen extends StatefulWidget {
  OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String smsCode = "";

  bool isLoading = false;

  String error = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(context),
      child: Builder(builder: (context) {
        return MultiBlocListener(
            listeners: [
                BlocListener<VerifyAccountBloc, VerifyAccountState>(
                  listener: (context, state) {
                    _buildListener(state, context);
                  },

                ),
                   BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                _buildAuthListener(state, context);
              },
            ),
            ],
                      child: Scaffold(
                    backgroundColor: Colors.white,
                    body: SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Image.asset(
                                  'assets/images/logo.jpg',
                                  height: 95,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              AppText(
                                AppLocalizations.of(context)?.confirmYourAccount ?? "",
                                color: Colors.black,
                                bold: true,
                                fontSize: 20,

                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              AppText(
                                AppLocalizations.of(context)?.enterThePinLabel ?? "",
                                color: const Color(0xffA8A8A8),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              PinCodeTextField(
                                appContext: context,
                                length: 4,
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
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                animationDuration: const Duration(milliseconds: 300),
                                // backgroundColor: Colors.white,
                                enableActiveFill: true,
                                // controller: controller,
                                onCompleted: (v) {
                                  print("Completed");
                                },
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    smsCode = value;
                                  });
                                },
                                beforeTextPaste: (text) {
                                  print("Allowing to paste //");
                                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                  return true;
                                },
                              ),
                              const SizedBox(
                                height: 100,
                              ),
                              SizedBox(
                                width: 250,
                                child:
                                    BlocBuilder<VerifyAccountBloc, VerifyAccountState>(
                                  builder: (context, state) {
                                    var loading = false;
                                    if (state is VerifyAccountLoading) {
                                      loading = true;
                                    }
                                    return AppButton(
                                      isLoading: loading,
                                      title: AppLocalizations.of(context)?.code ?? "",
                                      onTap: () {
                                        submit(context, smsCode);
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                    AppLocalizations.of(context)?.otpMessage3 ?? "",
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        BlocProvider.of<VerifyAccountBloc>(context)
                                            .add(ReSendCodeEvent());
                                      },
                                      child: AppText(
                                        AppLocalizations.of(context)?.otpMessage4 ?? "",
                                        fontSize: 12,
                                      )),
                                  const AppText(
                                    ' or ',
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        BlocProvider.of<AuthenticationBloc>(context)
                                            .add(LogOutUserEvent());
                                      },
                                      child: AppText(
                                        AppLocalizations.of(context)?.logoutLabel ?? "",
                                        color: Colors.blue,
                                        fontSize: 12,
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
        );
      }),
    );
  }

  void _buildListener(VerifyAccountState state, BuildContext context) {
     if (state is VerifyAccountOffline) {
      showSnackbar(context, 'No internet connection');
    } else if (state is VerifyAccountNetworkError) {
      showSnackbar(context,
          'An error occurred while sending, please try again \n ${state.message}');
    } else if (state is DoneResendCode) {
      ToastUtils.showSusToastMessage(
          "Otp has been resent successfully");
    } else if (state is DoneVerifyAccount) {
      BlocProvider.of<AuthenticationBloc>(context).add(LogInUserEvent());
    }
  }

  void _buildAuthListener(AuthenticationState state, BuildContext context) {
    if (state is AuthenticatedState) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppWrapper.routeName,
        (route) => false,
      );
    }
  }

  VerifyAccountBloc _getBloc(BuildContext context) {
    return VerifyAccountBloc(
      resendCodeUsecase: ResendCodeUsecase(
        authRepo: context.read<AuthRepo>(),
        verifyAccountRepo: VerifyAccountRepoImpl(
          verifyAccountDataSource:
              VerifyAccoutnDataSourceWithHttp(client: NetworkServiceHttp()),

        ),
      ),
      verifyAccountUsecase: VerifyAccountUsecase(
        authRepo: context.read<AuthRepo>(),
        verifyAccountRepo: VerifyAccountRepoImpl(
          verifyAccountDataSource:
              VerifyAccoutnDataSourceWithHttp(client: NetworkServiceHttp()),

        ),
      ),
    );
  }

  void submit(BuildContext context, String code) async {
    BlocProvider.of<VerifyAccountBloc>(context).add(SendCodeEvent(code: code));
  }
}
