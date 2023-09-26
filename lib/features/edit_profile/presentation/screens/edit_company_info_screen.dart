import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import 'package:masbar/features/edit_profile/presentation/screens/profile_info_screen.dart';

import '../../../../core/api_service/network_service_http.dart';
import '../../../../core/network/check_internet.dart';
import '../../../../core/ui/widgets/app_button.dart';
import '../../../../core/ui/widgets/app_text.dart';
import '../../../../core/ui/widgets/app_textfield.dart';
import '../../../../core/utils/helpers/helpers.dart';
import '../../../../core/utils/helpers/toast_utils.dart';
import '../../../auth/accounts/data/data sources/user_remote_data_source.dart';
import '../../../auth/accounts/data/repositories/user_repo_impl.dart';
import '../../data/data_source/update_profile_data_source.dart';
import '../../data/repositories/update_profile_repo_impl.dart';
import '../../domain/use_cases/update_company_profile_use_case.dart';
import '../bloc/edit_company_info_bloc.dart';

class EditCompanyInfoScreen extends StatefulWidget {
  static const routeName = 'edit_company_info_screen';
  EditCompanyInfoScreen({super.key});

  @override
  State<EditCompanyInfoScreen> createState() => _EditCompanyInfoScreenState();
}

class _EditCompanyInfoScreenState extends State<EditCompanyInfoScreen> {
  late int local;
  final formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController addressController = TextEditingController();
  @override
  void initState() {
    super.initState();
    local = context.read<AuthRepo>().getUserData()!.local!;
    firstNameController.text =
        context.read<AuthRepo>().getUserData()!.firstName!;
    addressController.text = context.read<AuthRepo>().getUserData()!.address!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(),
      child: Builder(builder: (context) {
        return BlocListener<EditCompanyInfoBloc, EditCompanyInfoState>(
          listener: (context, state) {
            _buildListener(state, context);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.editName),
            ),
            body: SingleChildScrollView(
              child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildLabel(context,
                            AppLocalizations.of(context)?.companyOwner ?? ""),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildCitizen(context),
                            const SizedBox(
                              width: 10,
                            ),
                            _buildNotCitizen(context),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        _buildLabel(context,
                            AppLocalizations.of(context)!.companyNameLabel),
                        AppTextField(
                          controller: firstNameController,
                          textInputAction: TextInputAction.next,
                          hintText:
                              AppLocalizations.of(context)?.enterFirstName ??
                                  "",
                          validator: (val) {
                            if (val.toString().isEmpty) {
                              return AppLocalizations.of(context)
                                      ?.firstNameError ??
                                  "";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        _buildLabel(
                            context, AppLocalizations.of(context)!.yourAddress),
                        AppTextField(
                          maxLines: 5,
                          minLines: 3,
                          textInputAction: TextInputAction.next,
                          controller: addressController,
                          labelText:
                              AppLocalizations.of(context)?.addressLabel ?? "",
                          hintText:
                              AppLocalizations.of(context)?.enterAddress ?? "",
                          validator: (val) {
                            if (val.toString().isEmpty) {
                              return AppLocalizations.of(context)
                                      ?.enterAddressError ??
                                  "";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        _buildSubmitBtn(context)
                      ],
                    ),
                  )),
            ),
          ),
        );
      }),
    );
  }

  void _buildListener(EditCompanyInfoState state, BuildContext context) {
    if (state is EditCompanyOfflineState) {
      ToastUtils.showErrorToastMessage('No internet connection');
    } else if (state is EditCompanyErrorState) {
      ToastUtils.showErrorToastMessage(state.message);
    } else if (state is DoneEditCompany) {
      ToastUtils.showSusToastMessage('Data has been changed Successfully');
      Navigator.pop(context);
           Navigator.pop(context);
     Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const ProfileInfoScreen(typeAuth: TypeAuth.company);
          },
        ),
      );
      // Navigator.pushNamedAndRemoveUntil(
      //   context,
      //   ProfileInfoScreen.routeName,
      //   (route) => false,
      //   arguments: {
      //     'typeAuth',
      //    TypeAuth.company
      //   },
      // );
    }
  }

  EditCompanyInfoBloc _getBloc() {
    return EditCompanyInfoBloc(
        updateCompanyProfileUseCase: UpdateCompanyProfileUseCase(
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

  Row _buildNotCitizen(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              local = 1;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    local == 1 ? Theme.of(context).primaryColor : Colors.white,
                border: local == 1
                    ? null
                    : Border.all(color: const Color(0xff9A9999), width: 1)),
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
    );
  }

  Row _buildCitizen(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              local = 0;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    local == 0 ? Theme.of(context).primaryColor : Colors.white,
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

  Widget _buildSubmitBtn(BuildContext context) {
    return Center(
      child: BlocBuilder<EditCompanyInfoBloc, EditCompanyInfoState>(
        builder: (context, state) {
          var loading = false;
          if (state is LoadingEditCompany) {
            loading = true;
          }
          return AppButton(
            isLoading: loading,
            title: AppLocalizations.of(context)?.save ?? "",
            onTap: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                BlocProvider.of<EditCompanyInfoBloc>(context).add(
                  EditCompanyEvent(
                    isCitizen: local,
                    companyName: firstNameController.text,
                    address: addressController.text,
                    state: context.read<AuthRepo>().getUserData()!.stateId!,
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
