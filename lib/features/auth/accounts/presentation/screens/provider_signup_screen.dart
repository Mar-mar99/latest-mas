import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/managers/languages_manager.dart';
import 'package:masbar/core/network/check_internet.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/core/utils/helpers/form_submission_state.dart';
import 'package:masbar/core/utils/helpers/snackbar.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';
import 'package:masbar/features/auth/accounts/data/data%20sources/user_remote_data_source.dart';
import 'package:masbar/features/auth/accounts/data/repositories/user_repo_impl.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import 'package:masbar/features/auth/accounts/domain/use%20cases/companysignup_usecase.dart';
import 'package:masbar/features/auth/accounts/presentation/bloc/authentication_bloc.dart';
import 'package:masbar/features/auth/accounts/presentation/bloc/company_signup_bloc.dart';
import 'package:masbar/features/auth/accounts/presentation/bloc/loggin_bloc.dart';
import 'package:masbar/features/auth/accounts/presentation/screens/login_screen.dart';
import 'package:masbar/features/auth/accounts/presentation/screens/add_document_company_screen.dart';
import 'package:masbar/features/localization/cubit/lacalization_cubit.dart';
import 'package:masbar/features/user_emirate/bloc/uae_states_bloc.dart';

import 'package:masbar/features/user_emirate/data/repositories/uae_state_repo_impl.dart';
import 'package:masbar/features/user_emirate/data/data sources/uae_states_remote_data_source.dart';
import 'package:masbar/core/ui/widgets/error_widget.dart';
import 'package:masbar/core/ui/widgets/loading_widget.dart';
import 'package:masbar/core/ui/widgets/no_connection_widget.dart';
import 'package:masbar/features/user_emirate/domain/entities/uae_state_entity.dart';
import 'package:masbar/features/user_emirate/domain/use%20cases/fetch_uae_states_usecase.dart';
import 'package:masbar/main.dart';
import 'package:http/http.dart';
import 'package:masbar/features/auth/accounts/domain/use%20cases/providersignup_usecase.dart';
import '../../../../../core/api_service/network_service_http.dart';
import '../../../../app_wrapper/app_wrapper.dart';
import '../screens/add_document_provider_screen.dart';
import 'package:masbar/core/ui/widgets/app_drop_down.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/features/auth/accounts/presentation/bloc/provider_signup_bloc.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_textfield.dart';

class ProviderSignupScreen extends StatefulWidget {
  static const routeName = 'provider_signup_screen';
  @override
  _ProviderSignupScreenState createState() => _ProviderSignupScreenState();
}

class _ProviderSignupScreenState extends State<ProviderSignupScreen>
    with SingleTickerProviderStateMixin {
  late Animation animation;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String error = '';
  String? countryCode;
  late AnimationController animationController;
  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode codeFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode retypePasswordFocus = FocusNode();
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode mobileNoFocus = FocusNode();
  bool isRemember = false;
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
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getSignupBloc(context),
        ),
      ],
      child: Builder(builder: (context) {
        return MultiBlocListener(
          listeners: [
            BlocListener<ProviderSignupBloc, ProviderSignupState>(
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
            body: SingleChildScrollView(
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildIntro(),
                      const SizedBox(
                        height: 35,
                      ),
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              _buildFirstNameField(context),
                               const SizedBox(
                                  height: 10,
                                ),
                              _buildLastNameField(context),
                               const SizedBox(
                                  height: 10,
                                ),
                              _buildPhoneField(context),
                               const SizedBox(
                                  height: 10,
                                ),
                              _buildCodeField(context),
                               const SizedBox(
                                  height: 10,
                                ),
                              _buildEmailField(context),
                               const SizedBox(
                                  height: 10,
                                ),
                              _buildPasswordField(context),
                               const SizedBox(
                                  height: 10,
                                ),
                              _buildConfirmPasswordField(context),
                              const SizedBox(
                                height: 10,
                              ),
                              _buildAddDocumentBtn(context),
                              _buildSubmitBtn(context),
                              _buildGoToLogin(context),
                              const SizedBox(
                                height: 100,
                              )
                            ],
                          ),
                        ),
                      ),
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

  void _buildListener(ProviderSignupState state, BuildContext context) {
if (state.validation == ProviderSignupValidation.lessThanTwoDocuments) {
      ToastUtils.showErrorToastMessage('You must add at least two documents');
    }
   else if (state.formSubmissionState is FormNoInternetState) {
      ToastUtils.showErrorToastMessage('No internet connection');
    } else if (state.formSubmissionState is FormNetworkErrorState) {
      ToastUtils.showErrorToastMessage(
          'An error occurred while sending, please try again \n ${(state.formSubmissionState as FormNetworkErrorState).message}');
    } else if (state.formSubmissionState is FormSuccesfulState) {
      BlocProvider.of<AuthenticationBloc>(context).add(LogInUserEvent());
    }
  }

  void _buildAuthListener(AuthenticationState state, BuildContext context) {
  if (state is OnBoardingState  ) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppWrapper.routeName,
        (route) => false,
      );
    }
  }

  ProviderSignupBloc _getSignupBloc(BuildContext context) {
    return ProviderSignupBloc(
      providerSignupUsecase: ProviderSignupUsecase(
        userRepo: UserRepoImpl(
          userRemoteDataSource: UserRemoteDataSourceWithHttp(client: NetworkServiceHttp()),

        ),
        authRepo: context.read<AuthRepo>(),
      ),
    );
  }

  AppTextField _buildFirstNameField(BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      focusNode: firstNameFocus,
      controller: firstNameController,
      labelText: "First Name",
      hintText: AppLocalizations.of(context)?.enterFirstName ?? "",
      onChanged: (value) {
        BlocProvider.of<ProviderSignupBloc>(context)
            .add(ProviderFirstNameChangedEvent(firstName: value));
      },
      validator: (val) {
        if (val.toString().isEmpty) {
          return AppLocalizations.of(context)?.firstNameError ?? "";
        }
        return null;
      },
    );
  }

  Row _buildGoToLogin(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          AppLocalizations.of(context)?.haveAnAccount ?? "",
          color: Colors.black,
          fontSize: 13,
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, LoginScreen.routeName, (route) => false);
          },
          child: AppText(
            AppLocalizations.of(context)?.login ?? "",
            bold: true,
            color: Colors.blue,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitBtn(BuildContext context) {
    return BlocBuilder<ProviderSignupBloc, ProviderSignupState>(
        builder: (context, state) {
      var isLoading = false;
      if (state.formSubmissionState is FormSubmittingState) {
        isLoading = true;
      }
      return Container(
        margin: const EdgeInsets.only(left: 5, right: 5),
        child: AppButton(
          buttonColor: ButtonColor.primary,
          title: AppLocalizations.of(context)?.signUp ?? "",
          isLoading: isLoading,

          onTap: () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              BlocProvider.of<ProviderSignupBloc>(context)
                  .add(ProviderSubmitEvent());
            }
          },
        ),
      );
    });
  }

  InkWell _buildAddDocumentBtn(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AddDocumentProviderScreen.routeName,
            arguments: {
              'bloc': BlocProvider.of<ProviderSignupBloc>(context),
            });
      },
      child: BlocBuilder<ProviderSignupBloc, ProviderSignupState>(
          buildWhen: (previous, current) {
        if (previous.documents != current.documents) {
          return true;
        } else {
          return false;
        }
      }, builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(top: 5, bottom: 15),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).primaryColor, width: 1),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: state.documents.isEmpty
                  ? [
                      Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                      ),
                      AppText(
                        AppLocalizations.of(context)?.addDocument ?? "",
                        color: Theme.of(context).primaryColor,
                      ),
                    ]
                  : [
                      AppText("${state.documents.length}",
                          color: Theme.of(context).primaryColor),
                      Icon(
                        Icons.file_copy_outlined,
                        color: Theme.of(context).primaryColor,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      AppText(
                        AppLocalizations.of(context)?.mangeDocument ?? "",
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
            ),
          ),
        );
      }),
    );
  }

  AppTextField _buildConfirmPasswordField(BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.done,
      focusNode: retypePasswordFocus,
      controller: retypePasswordController,
      type: "password",
      labelText: "Retype Password",
      hintText: AppLocalizations.of(context)?.retypePassword ?? "",
      onChanged: (value) {
        BlocProvider.of<ProviderSignupBloc>(context)
            .add(ProviderConfirmPasswordChangedEvent(confirmPassword: value));
      },
      validator: (value) {
        if (value!.isEmpty) {
          return AppLocalizations.of(context)?.errorPassword1 ?? "";
        } else if (value != passwordController.text) {
          return AppLocalizations.of(context)?.passwordNotMatch ?? "";
        }
        return null;
      },
    );
  }

  AppTextField _buildPasswordField(BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      focusNode: passwordFocus,
      controller: passwordController,
      type: "password",
      labelText: "Password",
      hintText: AppLocalizations.of(context)?.enterPassword ?? "",
      onChanged: (value) {
        BlocProvider.of<ProviderSignupBloc>(context)
            .add(ProviderPasswordChangedEvent(password: value));
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

  AppTextField _buildEmailField(BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      focusNode: emailFocus,
      controller: emailController,
      labelText: "Email",
      hintText: AppLocalizations.of(context)?.enterYourEmail ?? "",
      onChanged: (value) {
        BlocProvider.of<ProviderSignupBloc>(context)
            .add(ProviderEmailChangedEvent(email: value));
      },
      validator: (value) {
        if (value.toString().isEmpty) {
          return AppLocalizations.of(context)?.emailError1 ?? "";
        } else if (!value.toString().contains("@") ||
            !value.toString().contains(".")) {
          return AppLocalizations.of(context)?.emailError2 ?? "";
        }
        return null;
      },
    );
  }

  AppTextField _buildCodeField(BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      focusNode: codeFocus,
      controller: codeController,
      keyboardType: TextInputType.number,
      labelText: "Code",
      hintText: AppLocalizations.of(context)?.enterYourCode ?? "",
      onChanged: (value) {
        BlocProvider.of<ProviderSignupBloc>(context)
            .add(ProviderCodeChangedEvent(code: value));
      },
      validator: (value) {
        if (value.toString().isEmpty) {
          return AppLocalizations.of(context)?.enterYourCodeError ?? "";
        }
        return null;
      },
    );
  }

  AppTextField _buildPhoneField(BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      focusNode: mobileNoFocus,
      controller: mobileNoController,
      keyboardType: TextInputType.number,
      labelText: "Mobile No",
      hintText: AppLocalizations.of(context)?.enterMobile ?? "",
      prefix: AppText(
        '+971 ',
        color: Theme.of(context).primaryColor,
      ),
      onChanged: (value) {
        BlocProvider.of<ProviderSignupBloc>(context)
            .add(ProviderPhoneChangedEvent(phone: value));
      },
      validator: (value) {
        if (value.toString().trim().isEmpty) {
          return AppLocalizations.of(context)?.mobileError ?? "";
        } else if (value.toString().trim().length != 9) {
          return AppLocalizations.of(context)?.mobileError2 ?? "";
        }
        return null;
      },
    );
  }

  AppTextField _buildLastNameField(BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      focusNode: lastNameFocus,
      controller: lastNameController,
      labelText: "Last Name",
      hintText: AppLocalizations.of(context)?.enterLastName ?? "",
      onChanged: (value) {
        BlocProvider.of<ProviderSignupBloc>(context)
            .add(ProviderLastNameChangedEvent(lastName: value));
      },
      validator: (val) {
        if (val.toString().isEmpty) {
          return AppLocalizations.of(context)?.lastNameError ?? "";
        }
        return null;
      },
    );
  }

  Widget _buildIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 55),
          child: Image.asset(
            'assets/images/logo.jpg',
            height: 55,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 32),
          child: AppText(
            AppLocalizations.of(context)?.welcomeBack ?? "",
            bold: true,
            color: Colors.black,
            fontSize: 28,
          ),
        ),
        AppText(
          AppLocalizations.of(context)?.signUpToContinue ?? "",
          color: const Color(0xff888888),
          type: TextType.medium,
          fontSize: 18,
        ),
      ],
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
