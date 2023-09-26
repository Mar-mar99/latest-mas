import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/core/ui/widgets/app_button.dart';
import 'package:masbar/core/ui/widgets/app_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/ui/widgets/app_textfield.dart';

import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/network/check_internet.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/utils/helpers/snackbar.dart';
import '../../data/data sources/forget_password_data_source.dart';
import '../../data/repositories/forget_password_repo_impl.dart';
import '../../domain/use cases/send_email_forget_password_usecase.dart';
import '../bloc/send_email_forget_password_bloc.dart';
import 'change_password_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = 'forget_password_screen';
  ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  TypeAuth typeAuth = TypeAuth.user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(),
      child: Builder(builder: (context) {
        return BlocListener<SendEmailForgetPasswordBloc,
            SendEmailForgetPasswordState>(
          listener: (context, state) {
            _buildListener(state, context);
          },
          child: Scaffold(
              appBar: _buildAppbar(context),
              body: SingleChildScrollView(
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildImage(),
                          const SizedBox(
                            height: 20,
                          ),
                          _buildTitle(context),
                          const SizedBox(
                            height: 20,
                          ),
                          _buildEmailField(context),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildUserChoice(context),
                              const SizedBox(
                                height: 10,
                              ),
                              _buildCompanyChoice(context),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _buildSendButton(context)
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        );
      }),
    );
  }

  void _buildListener(
      SendEmailForgetPasswordState state, BuildContext context) {
    if (state is SendEmailForgetPasswordOfflineState) {
      showSnackbar(context, 'No internet connection');
    } else if (state is SendEmailForgetPasswordErrorState) {
      showSnackbar(context,
          'An error occurred while sending, please try again \n ${state.message}');
    } else if (state is DoneSendEmailForgetPassword) {
      Navigator.pushNamed(context, ChangePasswordScreen.routeName,arguments: {'id':state.id,"typeAuth":typeAuth});
    }
  }

  Row _buildCompanyChoice(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              typeAuth = TypeAuth.company;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: typeAuth == TypeAuth.company
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                border: typeAuth == TypeAuth.company
                    ? null
                    : Border.all(color: const Color(0xff9A9999), width: 1)),
            height: 22,
            width: 22,
            child: typeAuth == TypeAuth.company
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
              typeAuth = TypeAuth.company;
            });
          },
          child: AppText(
              AppLocalizations.of(context)?.forgetPasswordAsCompany ?? ""),
        )
      ],
    );
  }

  Row _buildUserChoice(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              typeAuth = TypeAuth.user;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: typeAuth == TypeAuth.user
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                border: typeAuth == TypeAuth.user
                    ? null
                    : Border.all(color: const Color(0xff9A9999), width: 1)),
            height: 22,
            width: 22,
            child: typeAuth == TypeAuth.user
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
              typeAuth = TypeAuth.user;
            });
          },
          child:
              AppText(AppLocalizations.of(context)?.forgetPasswordAsUser ?? ""),
        )
      ],
    );
  }

  AppText _buildTitle(BuildContext context) {
    return AppText(
      AppLocalizations.of(context)?.forgetPasswordTitle ?? "",
      textAlign: TextAlign.center,
    );
  }

  SendEmailForgetPasswordBloc _getBloc() {
    return SendEmailForgetPasswordBloc(
      sendEmailForgetPasswordUseCase: SendEmailForgetPasswordUseCase(
        forgetPasswordRepo: ForgetPasswordRepoImpl(
          forgetPasswordDataSource:
              ForgetPasswordDataSourceWithHttp(client: NetworkServiceHttp()),

        ),
      ),
    );
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      // backgroundColor: Colors.white,
      centerTitle: true,
      title: AppText(AppLocalizations.of(context)?.forgetPasswordAppBar ?? "",style:const TextStyle(color: Colors.white)),
      elevation: 0,
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return BlocBuilder<SendEmailForgetPasswordBloc,
        SendEmailForgetPasswordState>(
      builder: (context, state) {
        var isLoading = false;
        if (state is LoadingSendEmailForgetPassword) {
          isLoading = true;
        }
        return AppButton(
          title: AppLocalizations.of(context)?.send ?? "",
          isLoading: isLoading,
          onTap: () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              BlocProvider.of<SendEmailForgetPasswordBloc>(context).add(
                SendEmailEvent(
                  email: emailController.text,
                  typeAuth: typeAuth,
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return AppTextField(
        controller: emailController,
        labelText: AppLocalizations.of(context)?.emailLabel ?? "",
        validator: (value) {
          if (value.toString().isEmpty) {
            return AppLocalizations.of(context)?.emailError1 ?? "";
          } else if (!value.toString().contains("@") ||
              !value.toString().contains(".")) {
            return AppLocalizations.of(context)?.emailError2 ?? "";
          }
          return null;
        },
        hintText: AppLocalizations.of(context)?.enterYourEmail ?? "");
  }

  Container _buildImage() {
    return Container(
      margin: const EdgeInsets.only(top: 45),
      child: Image.asset(
        'assets/images/logo.jpg',
        height: 95,
      ),
    );
  }
}
