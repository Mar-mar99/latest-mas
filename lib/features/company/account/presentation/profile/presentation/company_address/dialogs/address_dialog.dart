// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/features/company/account/presentation/profile/presentation/company_address/bloc/update_address_bloc.dart';

import '../../../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../../../../core/utils/enums/enums.dart';
import '../../../../../../../../core/utils/helpers/toast_utils.dart';
import '../../../../../../../edit_profile/presentation/screens/profile_info_screen.dart';

class AddressDialog extends StatefulWidget {
  final String address;
  AddressDialog({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  State<AddressDialog> createState() => _AddressDialogState();
}

class _AddressDialogState extends State<AddressDialog> {
  final formKey = GlobalKey<FormState>();

  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller.text = widget.address;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateAddressBloc, UpdateAddressState>(
      listener: (context, state) {
        _buildAddressListener(state, context);
      },
      child: AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 30,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppText(AppLocalizations.of(context)?.address ?? ""),
            Form(
              key: formKey,
              child: Column(
                children: [
                  _buildAddressField(context),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            _buildSaveBtn(context),
          ],
        ),
      ),
    );
  }

  void _buildAddressListener(UpdateAddressState state, BuildContext context) {
     if (state is UpdateAddressOfflineState) {
      ToastUtils.showErrorToastMessage('No internet connection');
    } else if (state is UpdateAddressErrorState) {
      ToastUtils.showErrorToastMessage(state.message);
    } else if (state is LoadedUpdateAddress) {
      ToastUtils.showSusToastMessage(
          'Address has been changed Successfully');
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
    }
  }

  Widget _buildSaveBtn(BuildContext context) {
    return BlocBuilder<UpdateAddressBloc, UpdateAddressState>(
      builder: (context, state) {
        return AppButton(
          isLoading: state is LoadingUpdateAddress,
          onTap: () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              BlocProvider.of<UpdateAddressBloc>(context)
                  .add(UpdateAddress(address: controller.text));

            }
          },
          title: AppLocalizations.of(context)?.save ?? "",
        );
      },
    );
  }

  AppTextField _buildAddressField(BuildContext context) {
    return AppTextField(
      controller: controller,
      minLines: 3,
      maxLines: 5,
      hintText: AppLocalizations.of(context)!.errorEmptyReason,
      validator: (val) {
        if (val.toString().isEmpty) {
          return AppLocalizations.of(context)!.errorEmptyReason;
        }
        return null;
      },
    );
  }
}
