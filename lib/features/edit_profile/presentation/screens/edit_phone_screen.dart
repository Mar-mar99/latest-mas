import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/core/utils/helpers/helpers.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import 'package:masbar/features/edit_profile/presentation/screens/phone_verification_screen.dart';
import 'package:masbar/features/edit_profile/presentation/screens/profile_info_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/api_service/network_service_http.dart';
import '../../../../../core/network/check_internet.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../core/utils/helpers/form_submission_state.dart';
import '../../../../../core/utils/helpers/toast_utils.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../core/utils/helpers/custome_page_route.dart';
import '../../../auth/accounts/data/data sources/user_remote_data_source.dart';
import '../../../auth/accounts/data/repositories/user_repo_impl.dart';
import '../../data/data_source/update_profile_data_source.dart';

import '../../data/repositories/update_profile_repo_impl.dart';
import '../../domain/use_cases/update_phone_use_case.dart';
import '../bloc/update_phone_bloc.dart';

class EditPhoneScreen extends StatelessWidget {
  static const routeName = 'edit_phone_screen';
  EditPhoneScreen({super.key});
  final TextEditingController phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    phoneController.text = context.read<AuthRepo>().getUserData()!.mobile!;
    return BlocProvider(
      create: (context) => _getBloc(context),
      child: Builder(builder: (context) {
        return BlocListener<UpdatePhoneBloc, UpdatePhoneState>(
          listener: (context, state) {
            _buildListener(state, context);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.mobileNumber,
              ),
            ),
            body: SingleChildScrollView(
              child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildLabel(context),
                        const SizedBox(
                          height: 16,
                        ),
                        _buildPhoneField(context),
                        const SizedBox(
                          height: 16,
                        ),
                        _buildSubmitPhone(context),
                      ],
                    ),
                  )),
            ),
          ),
        );
      }),
    );
  }

  void _buildListener(UpdatePhoneState state, BuildContext context) {
    if (state is UpdatePhoneOfflineState) {
      ToastUtils.showErrorToastMessage('No internet connection');
    } else if (state is UpdatePhoneErrorState) {
      ToastUtils.showErrorToastMessage(state.message);
    } else if (state is DoneUpdatePhoneState) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
        context,
        CustomePageRoute(
          child: PhoneVerificationScreen(phone: phoneController.text),
          direction: AxisDirection.left,
        ),
      );
    }
  }

  Widget _buildSubmitPhone(BuildContext context) {
    return BlocBuilder<UpdatePhoneBloc, UpdatePhoneState>(
      builder: (context, state) {
        var loading = false;
        if (state is LoadingUpdatePhoneState) {
          loading = true;
        }
        return AppButton(
          title: AppLocalizations.of(context)?.saveLabel ?? "",
          isLoading: loading,
          onTap: () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              BlocProvider.of<UpdatePhoneBloc>(context).add(
                UserPhoneSubmitEvent(
                    typeAuth: Helpers.getUserTypeEnum(
                      context.read<AuthRepo>().getUserData()!.type!,
                    ),
                    phone: phoneController.text),
              );
            }
          },
        );
      },
    );
  }

  AppTextField _buildPhoneField(BuildContext context) {
    return AppTextField(
      hintText: AppLocalizations.of(context)?.enterMobileNumber ?? "",
      controller: phoneController,
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

  AppText _buildLabel(BuildContext context) {
    return AppText(
      AppLocalizations.of(context)?.mobileNumber ?? "",
      color: Colors.black,
      fontSize: 20,
      textAlign: TextAlign.center,
      fontWeight: FontWeight.bold,
    );
  }

  UpdatePhoneBloc _getBloc(BuildContext context) {
    return UpdatePhoneBloc(
        updatePhoneUseCase: UpdatePhoneUseCase(
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
