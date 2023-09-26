
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:masbar/features/auth/accounts/presentation/bloc/company_signup_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../widgets/document_item.dart';

class AddDocumentWidget extends StatelessWidget {
  final VoidCallback onClickHereHandler;
  final VoidCallback onAddDocumentBtn;
  final Widget DocumentListWidget;
  const AddDocumentWidget(
      {Key? key,
      required this.onClickHereHandler,
      required this.onAddDocumentBtn,
      required this.DocumentListWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.document,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Center(
                child: AppText(
                  AppLocalizations.of(context)?.guidelines ?? "",
                  bold: true,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              AppText(
                AppLocalizations.of(context)?.documentBody ?? "",
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              const SizedBox(
                height: 20,
              ),
              AppText(
                AppLocalizations.of(context)?.documentBody1 ?? "",
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 5,
              ),
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: AppLocalizations.of(context)?.documentBody2 ?? "",
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  _buildClickHere(context),
                  TextSpan(
                    text: AppLocalizations.of(context)?.documentBody3 ?? "",
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ]),
              ),
              const SizedBox(
                height: 16,
              ),
              DocumentListWidget
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AppButton(
          onTap: onAddDocumentBtn,
          title: AppLocalizations.of(context)?.addDocument ?? "",
        ),
      ),
    );
  }

  TextSpan _buildClickHere(BuildContext context) {
    return TextSpan(
        text: AppLocalizations.of(context)?.clickingHere ?? "",
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
        recognizer: TapGestureRecognizer()..onTap = onClickHereHandler);
  }
}
