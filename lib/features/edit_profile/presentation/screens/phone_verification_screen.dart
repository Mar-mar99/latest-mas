// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/core/network/check_internet.dart';
import 'package:masbar/features/edit_profile/domain/use_cases/verify_phone_use_case.dart';
import 'package:masbar/features/edit_profile/presentation/screens/profile_info_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/api_service/network_service_http.dart';
import '../../../../core/ui/widgets/app_button.dart';
import '../../../../core/ui/widgets/app_text.dart';
import '../../../../core/utils/helpers/helpers.dart';
import '../../../../core/utils/helpers/toast_utils.dart';
import '../../../auth/accounts/data/data sources/user_remote_data_source.dart';
import '../../../auth/accounts/data/repositories/user_repo_impl.dart';
import '../../../auth/accounts/domain/repositories/auth_repo.dart';
import '../../data/data_source/update_profile_data_source.dart';
import '../../data/repositories/update_profile_repo_impl.dart';
import '../bloc/verify_phone_bloc.dart';

class PhoneVerificationScreen extends StatefulWidget {
  static const routeName = 'phone_verification_screen';
  final String phone;
  const PhoneVerificationScreen({
    Key? key,
    required this.phone,
  }) : super(key: key);

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  String smsCode = '';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(context),
      child: Builder(builder: (context) {
        return BlocListener<VerifyPhoneBloc, VerifyPhoneState>(
          listener: (context, state) {
            _buildListener(state, context);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.phoneVerification),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom -
                        100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
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
                              Center(
                                child: Text(
                                  AppLocalizations.of(context)!.otpVerification,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Center(
                                child: Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .enterOtpSentTo,
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: widget.phone,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
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
                                    inactiveColor:
                                        Theme.of(context).dividerColor,
                                    activeColor: Theme.of(context).dividerColor,
                                    selectedColor:
                                        Theme.of(context).primaryColor,
                                    inactiveFillColor: Colors.white,
                                    selectedFillColor: Colors.white,
                                    fieldOuterPadding: const EdgeInsets.all(8)),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                animationDuration:
                                    const Duration(milliseconds: 300),
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
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        BlocBuilder<VerifyPhoneBloc, VerifyPhoneState>(
                          builder: (context, state) {
                            return AppButton(
                              isLoading: state is LoadingVerifyPhoneState,
                              title: AppLocalizations.of(context)!.verify,
                              onTap: () {
                                BlocProvider.of<VerifyPhoneBloc>(context).add(
                                    VerifyEvent(
                                        typeAuth: Helpers.getUserTypeEnum(
                                            context
                                                .read<AuthRepo>()
                                                .getUserData()!
                                                .type!),
                                        number: widget.phone,
                                        otpCode: smsCode));
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _buildListener(VerifyPhoneState state, BuildContext context) {
    if (state is VerifyPhoneOfflineState) {
      ToastUtils.showErrorToastMessage('No internet connection');
    } else if (state is VerifyPhoneErrorState) {
      ToastUtils.showErrorToastMessage(state.message);
    } else if (state is DoneVerifyPhoneState) {
       ToastUtils.showSusToastMessage('Phone Number changed successfully');
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ProfileInfoScreen(
                typeAuth: Helpers.getUserTypeEnum(
                    context.read<AuthRepo>().getUserData()!.type!));
          },
        ),
      );
    }
  }

  VerifyPhoneBloc _getBloc(BuildContext context) {
    return VerifyPhoneBloc(
        veifyPhoneUseCase: VeifyPhoneUseCase(
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
    ));
  }
}
