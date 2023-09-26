import 'package:flutter/material.dart';
import 'package:masbar/core/ui/widgets/app_textfield.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class EditDialog extends StatefulWidget {
  final String title;
  final String value;

  const EditDialog({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late TextEditingController controller;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
          style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Form(
          key: key,
          child: AppTextField(
            keyboardType: TextInputType.number,
            controller: controller,
            validator: (value) {
              if (double.tryParse(value!) == null) {
                return  AppLocalizations.of(context)!.make_sure_you_entered_a_valid_price;
                
              }
              return null;
            },
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [

          ElevatedButton(
            style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.withOpacity(.5),
        ),
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () {

                Navigator.of(context).pop();

            },
          ),
            ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor),
            child: Text(AppLocalizations.of(context)!.done),
            onPressed: () {
              final isValid = key.currentState!.validate();
              if (isValid) {
                Navigator.of(context).pop(controller.text);
              }
            },
          ),
        ],
      );
}
