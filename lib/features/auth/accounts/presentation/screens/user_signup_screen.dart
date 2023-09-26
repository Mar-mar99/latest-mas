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
import 'package:masbar/features/auth/accounts/domain/use%20cases/usersignup_usecase.dart';
import 'package:masbar/features/auth/accounts/presentation/bloc/authentication_bloc.dart';
import 'package:masbar/features/auth/accounts/presentation/bloc/loggin_bloc.dart';
import 'package:masbar/features/auth/accounts/presentation/screens/login_screen.dart';
import 'package:masbar/features/auth/accounts/presentation/screens/select_signup_type_screen.dart';
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
import 'package:masbar/core/ui/widgets/app_drop_down.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/features/auth/accounts/presentation/bloc/user_signup_bloc.dart';
import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../core/utils/helpers/email_validator.dart';
import '../../../../app_wrapper/app_wrapper.dart';

class UserSignupScreen extends StatelessWidget {
  static const routeName = 'usersignup_screen';
  UserSignupScreen({super.key});

  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getSignupBloc(context),
        ),
        BlocProvider(
          create: (context) => _getUAEStatesBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(body: BlocBuilder<UaeStatesBloc, UaeStatesState>(
            builder: (context, state) {
          if (state is LoadingUaeStates) {
            return const LoadingWidget();
          } else if (state is UAEStatesOfflineState) {
            return NoConnectionWidget(
              onPressed: () {
                BlocProvider.of<UaeStatesBloc>(context)
                    .add(FetchUaeStatesEvent());
              },
            );
          } else if (state is UAEStatesErrorState) {
            return NetworkErrorWidget(
              message: state.message,
              onPressed: () {
                BlocProvider.of<UaeStatesBloc>(context)
                    .add(FetchUaeStatesEvent());
              },
            );
          } else if (state is LoadedUaeStates) {
            return MultiBlocListener(
              listeners: [
                BlocListener<UserSignupBloc, UserSignupState>(
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
                          _buildLabel(context),
                          const SizedBox(
                            height: 35,
                          ),
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildFirstNameField(context),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _buildLastName(context),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _buildPhoneField(context),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _buildEmailField(context),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _buildStateDropDown(context, state),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _buildPassword(context),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _buildConfirmPassword(context),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  _buildSubmitBtn(context),
                                  _buildGoLogin(context),
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
          } else {
            return Container();
          }
        }));
      }),
    );
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
    )..add(FetchUaeStatesEvent());
  }

  AppDropDown<UAEStateEntity> _buildStateDropDown(
    BuildContext context,
    LoadedUaeStates state,
  ) {
    return AppDropDown<UAEStateEntity>(
      hintText: AppLocalizations.of(context)!.choose_your_emirate,
      items: state.states.map((e) => _buildDropMenuItem(context, e)).toList(),
      onChanged: (value) {
        BlocProvider.of<UserSignupBloc>(context)
            .add(StateChangedEvent(state: (value as UAEStateEntity).id));
      },
      initSelectedValue: null,
    );
  }

  void _buildListener(UserSignupState state, BuildContext context) {
    if(state.validation==SignupValidation.stateNotSelected){
         ToastUtils.showErrorToastMessage('You should select the state');
    }
    if (state.formSubmissionState is FormNoInternetState) {
      ToastUtils.showErrorToastMessage('No internet connection');
    } else if (state.formSubmissionState is FormNetworkErrorState) {
      ToastUtils.showErrorToastMessage(
          'An error occurred while sending, please try again \n ${(state.formSubmissionState as FormNetworkErrorState).message}');
    } else if (state.formSubmissionState is FormSuccesfulState) {
      BlocProvider.of<AuthenticationBloc>(context).add(LogInUserEvent());
    }
  }

  void _buildAuthListener(AuthenticationState state, BuildContext context) {
    if (state is VerificataionState) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppWrapper.routeName,
        (route) => false,
      );
    }
  }

  UserSignupBloc _getSignupBloc(BuildContext context) {
    return UserSignupBloc(
      signupUseCase: UserSignupUseCase(
        userRepo: UserRepoImpl(
          userRemoteDataSource: UserRemoteDataSourceWithHttp(client: NetworkServiceHttp()),

        ),
        authRepo: context.read<AuthRepo>(),
      ),
    );
  }

  Row _buildGoLogin(BuildContext context) {
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
    return BlocBuilder<UserSignupBloc, UserSignupState>(
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
                BlocProvider.of<UserSignupBloc>(context).add(SubmitEvent());
              }
            },
          ),
        );
      },
    );
  }

  AppTextField _buildConfirmPassword(BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.done,
      controller: retypePasswordController,
      type: "password",
      labelText: "Retype Password",
      hintText: AppLocalizations.of(context)?.retypePassword ?? "",
      onChanged: (value) {
        BlocProvider.of<UserSignupBloc>(context)
            .add(ConfirmPasswordChangedEvent(confirmPassword: value));
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
            .contains(RegExp(r'[!@#<>?":_`~;[\]\/¬£$%^|=+).,(*&^%-]'))) {
          return AppLocalizations.of(context)?.errorPassword4 ?? "";
        } else if (value.toString().trim() !=
            passwordController.text.toString().trim()) {
          return AppLocalizations.of(context)?.errorPassword5 ?? "";
        }
        return null;
      },
    );
  }

  AppTextField _buildPassword(BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      controller: passwordController,
      type: "password",
      labelText: "Password",
      hintText: AppLocalizations.of(context)?.enterPassword ?? "",
      onChanged: (value) {
        BlocProvider.of<UserSignupBloc>(context)
            .add(PasswordChangedEvent(password: value));
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
            .contains(RegExp(r'[!@#<>?":_`~;[\]\/¬£$%^|=+).,(*&^%-]'))) {
          return AppLocalizations.of(context)?.errorPassword4 ?? "";
        }
        return null;
      },
    );
  }

  AppTextField _buildEmailField(BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      controller: emailController,
      labelText: "Email",
      hintText: AppLocalizations.of(context)?.enterYourEmail ?? "",
      onChanged: (value) {
        BlocProvider.of<UserSignupBloc>(context)
            .add(EmailChangedEvent(email: value.trim()));
      },
      validator: (value) {
        if (value.toString().isEmpty) {
          return AppLocalizations.of(context)?.emailError1 ?? "";
        } else if (!isValidEmail(value!)) {
          return AppLocalizations.of(context)?.emailError2 ?? "";
        }
        return null;
      },
    );
  }

  AppTextField _buildPhoneField(BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      controller: mobileNoController,
      labelText: "Mobile No",
      hintText: AppLocalizations.of(context)?.enterMobile ?? "",
      onChanged: (value) {
        BlocProvider.of<UserSignupBloc>(context)
            .add(PhoneChangedEvent(phone: value));
      },
      prefix: AppText(
        '+971 ',
        color: Theme.of(context).primaryColor,
      ),
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

  AppTextField _buildLastName(BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      controller: lastNameController,
      labelText: "Last Name",
      hintText: AppLocalizations.of(context)?.enterLastName ?? "",
      onChanged: (value) {
        BlocProvider.of<UserSignupBloc>(context)
            .add(LastNameChangedEvent(lastName: value));
      },
      validator: (val) {
        if (val.toString().isEmpty) {
          return AppLocalizations.of(context)?.lastNameError ?? "";
        }
        return null;
      },
    );
  }

  AppTextField _buildFirstNameField(BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      controller: firstNameController,
      labelText: "First Name",
      hintText: AppLocalizations.of(context)?.enterFirstName ?? "",
      onChanged: (value) {
        BlocProvider.of<UserSignupBloc>(context)
            .add(FirstNameChangedEvent(firstName: value));
      },
      validator: (val) {
        if (val.toString().isEmpty) {
          return AppLocalizations.of(context)?.firstNameError ?? "";
        }
        return null;
      },
    );
  }

  Widget _buildLabel(BuildContext context) {
    return Column(
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
        )
      ],
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
