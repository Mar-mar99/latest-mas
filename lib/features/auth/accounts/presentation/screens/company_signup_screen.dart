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
import 'package:multi_select_flutter/multi_select_flutter.dart';
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

class CompanySignupScreen extends StatefulWidget {
  static const routeName = 'comapny_signup_screen';
  const CompanySignupScreen({super.key});

  @override
  State<CompanySignupScreen> createState() => _CompanySignupScreenState();
}

class _CompanySignupScreenState extends State<CompanySignupScreen>
    with SingleTickerProviderStateMixin {
  late Animation animation;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String error = '';
  String? countryCode;
  UAEStateEntity? selectedEmirate;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController(text: '');
  TextEditingController commissionNoController = TextEditingController();
  TextEditingController providersCountNoController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode retypePasswordFocus = FocusNode();
  FocusNode firstNameFocus = FocusNode();
  FocusNode addressNameFocus = FocusNode();
  FocusNode mobileNoFocus = FocusNode();
  FocusNode commissionFocus = FocusNode();
  FocusNode providersCountFocus = FocusNode();
  bool isAgreeTerm = false;
  int sendCode = 0;
  @override
  void initState() {
    super.initState();
  }

  int local = 0;

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
                BlocListener<CompanySignupBloc, CompanySignupState>(
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
              child: SingleChildScrollView(
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildCitizenNonCitizen(),
                                const SizedBox(
                                  height: 10,
                                ),
                                _buildCompanyNameField(firstNameFocus,
                                    firstNameController, context),
                                const SizedBox(
                                  height: 10,
                                ),
                                _buildPhoneField(
                                    mobileNoFocus, mobileNoController, context),
                                const SizedBox(
                                  height: 10,
                                ),
                                _buildEmailField(
                                    emailFocus, emailController, context),
                                const SizedBox(
                                  height: 10,
                                ),
                                _buildStatesSelection(context, state),
                                const SizedBox(
                                  height: 10,
                                ),
                                _buildMainBranchDropDown(),
                                const SizedBox(
                                  height: 10,
                                ),
                                _buildProviderCountField(providersCountFocus,
                                    providersCountNoController, context),
                                const SizedBox(
                                  height: 10,
                                ),
                                _buildPasswordField(
                                    passwordFocus, passwordController, context),
                                const SizedBox(
                                  height: 10,
                                ),
                                _buildConfirmPasswordField(
                                    retypePasswordFocus,
                                    retypePasswordController,
                                    context,
                                    passwordController),
                                const SizedBox(
                                  height: 10,
                                ),
                                _buildAddressField(addressNameFocus,
                                    addressController, context),
                                const SizedBox(
                                  height: 8,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                _buildSendTo(context),
                                const SizedBox(
                                  height: 16,
                                ),
                                Divider(),
                                const SizedBox(
                                  height: 16,
                                ),
                                _buildAgreeToTerms(context),
                                const SizedBox(
                                  height: 12,
                                ),
                                _buildAddDocument(context),
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
            );
          } else {
            return Container();
          }
        }));
      }),
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

  DropdownMenuItem<UAEStateEntity> _buildDropMenuItem(
      BuildContext context, UAEStateEntity e) {
    return DropdownMenuItem<UAEStateEntity>(
      value: e,
      child: Text(
        e.state,
      ),
    );
  }

  Widget _buildStatesSelection(
    BuildContext context,
    LoadedUaeStates state,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.withOpacity(.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: MultiSelectDialogField(
        searchable: false,
        isDismissible: true,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              5,
            ),
          ),
        ),
        chipDisplay: MultiSelectChipDisplay(
          onTap: null,
        ),
        listType: MultiSelectListType.LIST,
        title: Text(AppLocalizations.of(context)!.select_company_emirates),
        buttonText: Text(
          AppLocalizations.of(context)!.company_emirates,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        buttonIcon: Icon(Icons.location_city, color: Colors.grey[500]),
        items: state.states.map((e) => MultiSelectItem(e, e.state)).toList(),
        onSelectionChanged: (values) {},
        onConfirm: (values) {
          List<UAEStateEntity> selectedData = [];
          for (var i = 0; i < values.length; i++) {
            UAEStateEntity data = values[i] as UAEStateEntity;
            selectedData.add(data);
          }
          BlocProvider.of<CompanySignupBloc>(context).add(
            CompanyStateChangedEvent(
              states: selectedData,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainBranchDropDown() {
    return BlocBuilder<CompanySignupBloc, CompanySignupState>(
      builder: (context, state) {
        if (state.states.isEmpty) {
          return Container();
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.withOpacity(.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                child: DropdownButton<UAEStateEntity>(
                  value: state.mainBranch == UAEStateEntity.empty()
                      ? null
                      : state.mainBranch,
                  hint: Text(
                    AppLocalizations.of(context)!.main_branch,
                    style:
                        const TextStyle(fontSize: 14, color: Color(0xff888888)),
                  ),
                  items: state.states
                      .map((e) => _buildDropMenuItem(context, e))
                      .toList(),
                  onChanged: (value) {
                    BlocProvider.of<CompanySignupBloc>(context).add(
                      CompanyMainBranchChangedEvent(mainBranch: value!),
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
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

  void _buildListener(CompanySignupState state, BuildContext context) {
    if (state.signupValidation == CompanySignupValidation.statesEmpty) {
      ToastUtils.showErrorToastMessage('You must select company emirates');
    } else if (state.signupValidation ==
        CompanySignupValidation.mainBranchNotSelected) {
      ToastUtils.showErrorToastMessage('You must select company main branch');
    } else if (state.signupValidation == CompanySignupValidation.hasnotAgreed) {
      ToastUtils.showErrorToastMessage('You must agree on Masbar terms');
    } else if (state.signupValidation ==
        CompanySignupValidation.lessThanTwoDocuments) {
      ToastUtils.showErrorToastMessage('You must add at least two documents');
    } else if (state.formSubmissionState is FormNoInternetState) {
      ToastUtils.showErrorToastMessage('No internet connection');
    } else if (state.formSubmissionState is FormNetworkErrorState) {
      ToastUtils.showErrorToastMessage(
          'An error occurred while sending, please try again \n ${(state.formSubmissionState as FormNetworkErrorState).message}');
    } else if (state.formSubmissionState is FormSuccesfulState) {
      BlocProvider.of<AuthenticationBloc>(context).add(LogInUserEvent());
    }
  }

  void _buildAuthListener(AuthenticationState state, BuildContext context) {
    if (state is OnBoardingState) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppWrapper.routeName,
        (route) => false,
      );
    }
  }

  CompanySignupBloc _getSignupBloc(BuildContext context) {
    return CompanySignupBloc(
      companySignupUseCase: CompanySignupUseCase(
        userRepo: UserRepoImpl(
          userRemoteDataSource: UserRemoteDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
        authRepo: context.read<AuthRepo>(),
      ),
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
            height: 65,
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
          AppLocalizations.of(context)?.signUpAsCompany ?? "",
          color: const Color(0xff888888),
          type: TextType.medium,
          fontSize: 18,
        )
      ],
    );
  }

  InkWell _buildAddDocument(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AddDocumentCompanyScreen.routeName,
          arguments: {
            'bloc': BlocProvider.of<CompanySignupBloc>(context),
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1),
        ),
        child: BlocBuilder<CompanySignupBloc, CompanySignupState>(
          buildWhen: (previous, current) {
            if (previous.documents != current.documents) {
              return true;
            } else {
              return false;
            }
          },
          builder: (context, state) {
            return Center(
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildSendTo(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          AppText(AppLocalizations.of(context)?.sendCodeTo ?? ""),
        ],
      ),
      const SizedBox(
        height: 16,
      ),
      Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                sendCode = 0;
              });
              BlocProvider.of<CompanySignupBloc>(context).add(
                  CompanyVerifyByChangedEvent(
                      verifyByType: VerifyByType.email));
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: sendCode == 0
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  border: sendCode == 0
                      ? null
                      : Border.all(color: const Color(0xff9A9999), width: 1)),
              height: 22,
              width: 22,
              child: sendCode == 0
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
                sendCode = 0;
              });
              BlocProvider.of<CompanySignupBloc>(context).add(
                  CompanyVerifyByChangedEvent(
                      verifyByType: VerifyByType.email));
            },
            child: AppText(AppLocalizations.of(context)?.emailLabel ?? ""),
          )
        ],
      ),
      const SizedBox(
        height: 12,
      ),
      Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                sendCode = 1;
              });
              BlocProvider.of<CompanySignupBloc>(context).add(
                  CompanyVerifyByChangedEvent(verifyByType: VerifyByType.sms));
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: sendCode == 1
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  border: sendCode == 1
                      ? null
                      : Border.all(color: const Color(0xff9A9999), width: 1)),
              height: 22,
              width: 22,
              child: sendCode == 1
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
                sendCode = 1;
              });
              BlocProvider.of<CompanySignupBloc>(context).add(
                  CompanyVerifyByChangedEvent(verifyByType: VerifyByType.sms));
            },
            child: AppText(AppLocalizations.of(context)?.sMS ?? ""),
          )
        ],
      )
    ]);
  }

  Widget _buildAddressField(FocusNode addressNameFocus,
      TextEditingController addressController, BuildContext context) {
    return AppTextField(
      maxLines: 5,
      minLines: 3,
      textInputAction: TextInputAction.next,
      focusNode: addressNameFocus,
      controller: addressController,
      labelText: "Address",
      hintText: AppLocalizations.of(context)?.enterAddress ?? "",
      onChanged: (value) {
        BlocProvider.of<CompanySignupBloc>(context)
            .add(CompanyAddressChangedEvent(address: value));
      },
      validator: (val) {
        if (val.toString().isEmpty) {
          return AppLocalizations.of(context)?.enterAddressError ?? "";
        }

        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField(
      FocusNode retypePasswordFocus,
      TextEditingController retypePasswordController,
      BuildContext context,
      TextEditingController passwordController) {
    return AppTextField(
      textInputAction: TextInputAction.done,
      focusNode: retypePasswordFocus,
      controller: retypePasswordController,
      type: "password",
      labelText: AppLocalizations.of(context)?.retypePassword ?? "",
      hintText: AppLocalizations.of(context)?.retypePassword ?? "",
      onChanged: (value) {
        BlocProvider.of<CompanySignupBloc>(context)
            .add(CompanyConfirmPasswordChangedEvent(confirmPassword: value));
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

  Widget _buildPasswordField(FocusNode passwordFocus,
      TextEditingController passwordController, BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      focusNode: passwordFocus,
      controller: passwordController,
      type: "password",
      labelText: AppLocalizations.of(context)?.password ?? "",
      hintText: AppLocalizations.of(context)?.enterPassword ?? "",
      onChanged: (value) {
        BlocProvider.of<CompanySignupBloc>(context)
            .add(CompanyPasswordChangedEvent(password: value));
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

  Widget _buildProviderCountField(FocusNode providersCountFocus,
      TextEditingController providersCountNoController, BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      focusNode: providersCountFocus,
      controller: providersCountNoController,
      labelText: AppLocalizations.of(context)?.providersCountLabel ?? "",
      hintText: AppLocalizations.of(context)?.enterYourProvidersCount ?? "",
      onChanged: (value) {
        if (int.tryParse(value) != null) {}
        BlocProvider.of<CompanySignupBloc>(context).add(
          CompanyProviderCountChangedEvent(
            count: int.parse(
              value,
            ),
          ),
        );
      },
      validator: (value) {
        if (value.toString().isEmpty) {
          return AppLocalizations.of(context)?.enterYourProvidersCountError ??
              "";
        } else if (int.tryParse(value.toString()) == null) {
          return 'Enter a valid count number';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField(FocusNode emailFocus,
      TextEditingController emailController, BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      focusNode: emailFocus,
      controller: emailController,
      labelText: AppLocalizations.of(context)?.emailLabel ?? "",
      hintText: AppLocalizations.of(context)?.enterYourEmail ?? "",
      onChanged: (value) {
        BlocProvider.of<CompanySignupBloc>(context)
            .add(CompanyEmailChangedEvent(email: value.trim()));
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

  Widget _buildPhoneField(FocusNode mobileNoFocus,
      TextEditingController mobileNoController, BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      focusNode: mobileNoFocus,
      controller: mobileNoController,
      labelText: AppLocalizations.of(context)?.mobileNoLabel ?? "",
      hintText: AppLocalizations.of(context)?.enterMobile ?? "",
      prefix: AppText(
        '+971 ',
        color: Theme.of(context).primaryColor,
      ),
      onChanged: (value) {
        BlocProvider.of<CompanySignupBloc>(context)
            .add(CompanyPhoneChangedEvent(phone: value));
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

  Widget _buildCompanyNameField(FocusNode firstNameFocus,
      TextEditingController firstNameController, BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      focusNode: firstNameFocus,
      controller: firstNameController,
      labelText: AppLocalizations.of(context)?.companyNameLabel ?? "",
      hintText: AppLocalizations.of(context)?.companyNameLabel ?? "",
      onChanged: (value) {
        BlocProvider.of<CompanySignupBloc>(context)
            .add(CompanyNameChangedEvent(companyName: value));
      },
      validator: (val) {
        if (val.toString().isEmpty) {
          return AppLocalizations.of(context)?.companyNameError ?? "";
        }
        return null;
      },
    );
  }

  Widget _buildCitizenNonCitizen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)?.companyOwner ?? ""),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    BlocProvider.of<CompanySignupBloc>(context).add(
                        const CompanyTypeChangedEvent(
                            companyOwnerType: CompanyOwnerType.citizen));

                    setState(() {
                      local = 0;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: local == 0
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        border: local == 0
                            ? null
                            : Border.all(color: Color(0xff9A9999), width: 1)),
                    height: 22,
                    width: 22,
                    child: local == 0
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
                      local = 0;
                    });
                  },
                  child: AppText(
                    AppLocalizations.of(context)?.citizen ?? "",
                  ),
                )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    BlocProvider.of<CompanySignupBloc>(context).add(
                        const CompanyTypeChangedEvent(
                            companyOwnerType: CompanyOwnerType.nonCitizen));

                    setState(() {
                      local = 1;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: local == 1
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        border: local == 1
                            ? null
                            : Border.all(
                                color: const Color(0xff9A9999), width: 1)),
                    height: 22,
                    width: 22,
                    child: local == 1
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
                      local = 1;
                    });
                  },
                  child: AppText(
                    AppLocalizations.of(context)?.noncitizen ?? "",
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAgreeToTerms(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            BlocProvider.of<CompanySignupBloc>(context)
                .add(CompanyAgreeChangedEvent(hasAgreed: !isAgreeTerm));
            setState(() {
              isAgreeTerm = !isAgreeTerm;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color:
                    isAgreeTerm ? Theme.of(context).primaryColor : Colors.white,
                border: isAgreeTerm
                    ? null
                    : Border.all(color: const Color(0xff9A9999), width: 1)),
            height: 22,
            width: 22,
            child: isAgreeTerm
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
              isAgreeTerm = !isAgreeTerm;
            });
          },
          child:
              AppText(AppLocalizations.of(context)?.iAgreeToMesbarTerm ?? ""),
        )
      ],
    );
  }

  Widget _buildSubmitBtn(BuildContext context) {
    return BlocBuilder<CompanySignupBloc, CompanySignupState>(
        builder: (context, state) {
      var isLoading = false;
      if (state.formSubmissionState is FormSubmittingState) {
        isLoading = true;
      }
      return AppButton(
          buttonColor: ButtonColor.primary,
          title: AppLocalizations.of(context)?.signUp ?? "",
          isLoading: isLoading,
          // isDisabled: authProvider.documentsCompany.isEmpty ||
          //     !isAgreeTerm ||
          //     sendCode == -1,
          onTap: () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();

              BlocProvider.of<CompanySignupBloc>(context)
                  .add(CompanySubmitEvent());
            }
          });
    });
  }
}
