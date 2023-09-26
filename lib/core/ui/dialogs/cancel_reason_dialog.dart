// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/app_button.dart';
import '../widgets/app_text.dart';
import '../widgets/app_textfield.dart';

class CancelReasonDialog extends StatelessWidget {
  final Function handler;
  CancelReasonDialog({
    Key? key,
    required this.handler,
  }) : super(key: key);
  final formKey = GlobalKey<FormState>();
  TextEditingController cancelTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 30,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppText(AppLocalizations.of(context)?.cancelReason ?? ""),
          Form(
            key: formKey,
            child: Column(
              children: [
                _buildCancelField(context),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          _buildSaveBtn(context),
        ],
      ),
    );
  }

  AppButton _buildSaveBtn(BuildContext context) {
    return AppButton(
      onTap: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          await handler(cancelTextEditingController.text);

          Navigator.pop(context);
        }
      },
      title: AppLocalizations.of(context)?.save ?? "",
    );
  }

  AppTextField _buildCancelField(BuildContext context) {
    return AppTextField(
      controller: cancelTextEditingController,
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
