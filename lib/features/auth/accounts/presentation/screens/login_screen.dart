import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/managers/languages_manager.dart';
import 'package:masbar/core/network/check_internet.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/core/utils/helpers/snackbar.dart';
import 'package:masbar/features/auth/accounts/data/data%20sources/user_remote_data_source.dart';
import 'package:masbar/features/auth/accounts/data/repositories/user_repo_impl.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import 'package:masbar/features/auth/accounts/domain/use%20cases/login_usecase.dart';
import 'package:masbar/features/auth/accounts/presentation/bloc/authentication_bloc.dart';
import 'package:masbar/features/auth/accounts/presentation/bloc/loggin_bloc.dart';
import 'package:masbar/features/auth/accounts/presentation/bloc/social_login_bloc.dart';
import 'package:masbar/features/auth/accounts/presentation/screens/select_signup_type_screen.dart';
import 'package:masbar/features/localization/cubit/lacalization_cubit.dart';
import 'package:masbar/features/user_emirate/bloc/uae_states_bloc.dart';
import 'package:masbar/main.dart';
import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../core/ui/dialogs/loading_dialog.dart';
import '../../../../app_wrapper/app_wrapper.dart';
import '../../../../user_emirate/data/data sources/uae_states_remote_data_source.dart';
import '../../../../user_emirate/data/repositories/uae_state_repo_impl.dart';
import '../../../../user_emirate/domain/use cases/fetch_uae_states_usecase.dart';
import '../../data/data sources/social_remote_data_source.dart';
import '../../data/repositories/social_repo_impl.dart';
import '../../domain/use cases/fetch_social_user_usecase.dart';
import '../../domain/use cases/social_login_usecase.dart';
import '../widgets/gmail_login_btn.dart';
import '../widgets/facebook_login_button.dart';
import '../widgets/apple_login_btn.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/core/utils/helpers/form_submission_state.dart';
import '../widgets/states_dialog.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login_screen';
  // final dynamic Function({required int page}) goToPage;

  // const LoginScreen({Key? key, required this.goToPage}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late Animation animation;

  late AnimationController animationController;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  bool isRemember = false;
  final formKey = GlobalKey<FormState>();
  int val = 1;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(seconds: 3),
        vsync: this,
        value: 0,
        lowerBound: 0,
        upperBound: 1);

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getSocialBloc(context),
        ),
        BlocProvider(
          create: (context) => _getUAEStatesBloc(),
        ),
        BlocProvider(
          create: (context) => _getLoginBloc(context),
        ),
      ],
      child: Builder(builder: (context) {
        return MultiBlocListener(
          listeners: [
            BlocListener<LogginBloc, LogginState>(
              listener: (context, state) {
                _buildLoginListener(state, context);
              },
            ),
            BlocListener<SocialLoginBloc, SocialLoginState>(
              listener: (context, state) {
                _buildSocialLoginListener(state, context);
              },
            ),
            BlocListener<UaeStatesBloc, UaeStatesState>(
              listener: (context, state) {
                _buildUAEListener(state, context);
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
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: FractionallySizedBox(
                    widthFactor: 0.90,
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLanguage(),
                          _buildImage(),
                          // const SizedBox(
                          //   height: 40,
                          // ),
                          _buildEmailField(context),
                          const SizedBox(
                            height: 10,
                          ),
                          _buildPasswordField(context),

                          _buildForgetPassword(context),
                          // const SizedBox(
                          //   height: 15,
                          // ),
                          _buildSelectorType(context),
                          const SizedBox(
                            height: 8,
                          ),

                          _buildSigninBtn(context),
                          if (val != 2)
                            Column(
                              children: [
                                _buildOrSection(context),
                                const SizedBox(
                                  height: 8,
                                ),
                                _buildSocialBtn(),
                              ],
                            ),
                          _buildCreateAccountBtn(context),
                        ],
                      ),
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

  void _buildSocialLoginListener(SocialLoginState state, BuildContext context) {
   if (state.socialLoginCurrentState ==
        SocialLoginCurrentState.loadingUserInfo) {
       showLoadingDialog(context);
    }
    if (state.socialLoginCurrentState ==
        SocialLoginCurrentState.fetchedUserInfoSuccessfuly) {
            if (_isThereCurrentDialogShowing(context)) {
        Navigator.pop(context);
      }
      BlocProvider.of<UaeStatesBloc>(context).add(FetchUaeStatesEvent());
    } else if (state.socialLoginCurrentState ==
        SocialLoginCurrentState.loadingLogin) {
      showLoadingDialog(context);
    } else if (state.socialLoginCurrentState ==
        SocialLoginCurrentState.loggedSuccessfuly) {
           if (_isThereCurrentDialogShowing(context)) {
        Navigator.pop(context);
      }
      BlocProvider.of<AuthenticationBloc>(context).add(LogInUserEvent());
    } else if (state.socialLoginCurrentState ==
        SocialLoginCurrentState.offline) {
      if (_isThereCurrentDialogShowing(context)) {
        Navigator.pop(context);
      }
      showSnackbar(context, 'No internet connection');
    } else if (state.socialLoginCurrentState == SocialLoginCurrentState.error) {
      if (_isThereCurrentDialogShowing(context)) {
        Navigator.pop(context);
      }
      showSnackbar(
          context, 'An error occurred while sending, please try again');
    }
  }

  _isThereCurrentDialogShowing(BuildContext context) {
    print('is dialog opened ${ModalRoute.of(context)?.isCurrent!= true}');
  return  ModalRoute.of(context)?.isCurrent != true;
  }

  void _buildUAEListener(UaeStatesState state, BuildContext context) {
    if (state is LoadingUaeStates) {
      showLoadingDialog(context);
    }
    if (state is LoadedUaeStates) {
      if (_isThereCurrentDialogShowing(context)) {
        Navigator.pop(context);
      }
      showStatesDialog(
        context,
        state.states,
        BlocProvider.of<SocialLoginBloc>(
          context,
        ),
      );
    } else if (state is UAEStatesOfflineState) {
      if (_isThereCurrentDialogShowing(context)) {
        Navigator.pop(context);
      }
      showSnackbar(context, 'No internet connection');
    } else if (state is UAEStatesErrorState) {
      if (_isThereCurrentDialogShowing(context)) {
        Navigator.pop(context);
      }
      showSnackbar(
          context, 'An error occurred while sending, please try again');
    }
  }

  UaeStatesBloc _getUAEStatesBloc() {
    return UaeStatesBloc(
      fetchUaeStatesUseCase: FetchUaeStatesUseCase(
        uaeStatesRepo: UAEStatesRepoImpl(
          uaeStatesRemoteDataSource:
              UAEStatesDataSourceWithHttp(client: Client()),
          networkInfo: NetworkInfoImpl(
            internetConnectionChecker: InternetConnectionChecker(),
          ),
        ),
      ),
    );
  }

  SocialLoginBloc _getSocialBloc(BuildContext context) {
    return SocialLoginBloc(
      socialLoginUseCase: SocialLoginUseCase(
          authRepo: context.read<AuthRepo>(),
          userRepo: UserRepoImpl(
            userRemoteDataSource:
                UserRemoteDataSourceWithHttp(client: NetworkServiceHttp()),

          )),
      fetchSocialUserUseCase: FetchSocialUserUseCase(
        socialRepo: SocialRepoImpl(
          socialSource: SocialSource(),
          networkInfo: NetworkInfoImpl(
            internetConnectionChecker: InternetConnectionChecker(),
          ),
        ),
      ),
    );
  }

  void _buildLoginListener(LogginState state, BuildContext context) {
    if (state.formSubmissionState is FormNoInternetState) {
      showSnackbar(context, 'No internet connection');
    } else if (state.formSubmissionState is FormNetworkErrorState) {
      showSnackbar(context,
          'An error occurred while sending, please try again \n ${(state.formSubmissionState as FormNetworkErrorState).message}');
    } else if (state.formSubmissionState is FormSuccesfulState) {
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

  LogginBloc _getLoginBloc(BuildContext context) {
    return LogginBloc(
      loginUseCase: LoginUseCase(
        userRepo: UserRepoImpl(
          userRemoteDataSource: UserRemoteDataSourceWithHttp(client: NetworkServiceHttp()),

        ),
        authRepo: context.read<AuthRepo>(),
      ),
    );
  }

  Widget _buildLanguage() {
    return BlocBuilder<LacalizationCubit, LacalizationState>(
      builder: (context, state) {
        return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          TextButton(
            onPressed: () {
              BlocProvider.of<LacalizationCubit>(context).changeLanguage(
                  state.locale.languageCode == LanguagesManager.Arabic
                      ? LanguagesManager.English
                      : LanguagesManager.Arabic);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
            child: Text(
              state.locale.languageCode == LanguagesManager.English
                  ? 'عربي'
                  : 'English',
              style: const TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
          )
        ]);
      },
    );
  }

  Widget _buildOrSection(BuildContext context) {
    return Row(children: [
      const Expanded(
          child: Divider(
        thickness: 1,
      )),
      const SizedBox(
        width: 8,
      ),
      Text("${AppLocalizations.of(context)?.or}"),
      const SizedBox(
        width: 8,
      ),
      const Expanded(
        child: Divider(
          thickness: 1,
        ),
      ),
    ]);
  }

  Row _buildCreateAccountBtn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          AppLocalizations.of(context)?.dontHaveAnAccount ?? "",
          color: Colors.black,
          fontSize: 13,
        ),
        InkWell(
          onTap: () async {
            Navigator.pushNamed(context, SelectSignupTypeScreen.routeName);
          },
          child: AppText(
            AppLocalizations.of(context)?.register ?? "",
            bold: true,
            color: Colors.blue,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Column _buildSocialBtn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        GmailLoginBtn(),
        SizedBox(
          height: 8,
        ),
        FacebookLoginBtn(),
        SizedBox(
          height: 8,
        ),
        AppleLoginBtn(),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget _buildSigninBtn(BuildContext context) {
    return BlocBuilder<LogginBloc, LogginState>(
      builder: (context, state) {
        var isLoading = false;
        if (state.formSubmissionState is FormSubmittingState) {
          isLoading = true;
        }
        return Container(
          child: AppButton(
            buttonColor: ButtonColor.primary,
            title: AppLocalizations.of(context)?.signIn ?? "",
            isLoading: isLoading,
            onTap: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                BlocProvider.of<LogginBloc>(context).add(SubmitLogginEvent(
                    loginUserType:
                        val == 1 ? LoginUserType.user : LoginUserType.company));
              }
            },
          ),
        );
      },
    );
  }

  Column _buildSelectorType(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  val = 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: val == 1
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    border: val == 1
                        ? null
                        : Border.all(color: const Color(0xff9A9999), width: 1)),
                height: 22,
                width: 22,
                child: val == 1
                    ? const Icon(
                        Icons.check,
                        size: 20.0,
                        color: Colors.white,
                      )
                    : Container(),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  val = 1;
                });
              },
              child: AppText(
                AppLocalizations.of(context)?.signInAsUser ?? "",
              ),
            )
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  val = 2;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: val == 2
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    border: val == 2
                        ? null
                        : Border.all(color: const Color(0xff9A9999), width: 1)),
                height: 22,
                width: 22,
                child: val == 2
                    ? const Icon(
                        Icons.check,
                        size: 20.0,
                        color: Colors.white,
                      )
                    : Container(),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  val = 2;
                });
              },
              child: AppText(
                AppLocalizations.of(context)?.signInAsCompany ?? "",
              ),
            )
          ],
        ),
      ],
    );
  }

  InkWell _buildForgetPassword(BuildContext context) {
    return InkWell(
      onTap: () {
       Navigator.pushNamed(context, ForgetPasswordScreen.routeName);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppText(
            AppLocalizations.of(context)?.forgetPassword ?? "",
            color: Colors.black,
            fontSize: 13,
            bold: true,
          ),
        ],
      ),
    );
  }

  AppTextField _buildPasswordField(BuildContext context) {
    return AppTextField(
      focusNode: passwordFocus,
      controller: passwordController,
      textInputAction: TextInputAction.done,
      type: "password",
      labelText: "Password",
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
      hintText: AppLocalizations.of(context)?.enterPassword ?? "",
      onChanged: (value) {
        BlocProvider.of<LogginBloc>(context)
            .add(PasswordLogginChangedEvent(password: value));
      },
    );
  }

  AppTextField _buildEmailField(BuildContext context) {
    return AppTextField(
      focusNode: emailFocus,
      controller: emailController,
      textInputAction: TextInputAction.next,
      labelText: "Email",
      validator: (value) {
        if (value.toString().isEmpty) {
          return AppLocalizations.of(context)?.emailError1 ?? "";
        } else if (!value.toString().contains("@") ||
            !value.toString().contains(".")) {
          return AppLocalizations.of(context)?.emailError2 ?? "";
        }
        return null;
      },
      hintText: AppLocalizations.of(context)?.enterYourEmail ?? "",
      onChanged: (value) {
        BlocProvider.of<LogginBloc>(context)
            .add(EmailLogginChangedEvent(email: value));
      },
    );
  }

  Container _buildImage() {
    return Container(
      child: Image.asset(
        'assets/images/logo.jpg',
        height: 95,
      ),
    );
  }
}
