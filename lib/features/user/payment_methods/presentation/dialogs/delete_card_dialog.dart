import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_dialog.dart';
import '../../../../../core/ui/widgets/app_text.dart';

dialogDeletePayment(
  context,
  VoidCallback callback,
) {
  showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        bool isLoading = false;
        return DialogItem(
            icon: Icon(
              EvaIcons.trash2,
              size: 65,
              color: Theme.of(context).primaryColor,
            ),
            paragraph: AppLocalizations.of(context)!.deletedCardMessage,
            nextButtonText: AppLocalizations.of(context)!.yesLabel,
            cancelButtonText: AppLocalizations.of(context)!.noLabel,
            nextButtonFunction: () {
              callback();
              Navigator.pop(context);
            },
            cancelButtonFunction: () {
              Navigator.pop(context);
            });
      });
}

   dialogSuccess(context, ) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
               const Icon(
                  EvaIcons.checkmark,
                  color:  Colors.green,
                  size: 65,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  AppLocalizations.of(context)!.cardMainPaymentMethodMessage,
                  textAlign: TextAlign.center,

                ),
                const SizedBox(
                  height: 24,
                ),
                AppButton(
                  title: AppLocalizations.of(context)!.done,

                  buttonColor: ButtonColor.primary,
                  onTap: () async {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
