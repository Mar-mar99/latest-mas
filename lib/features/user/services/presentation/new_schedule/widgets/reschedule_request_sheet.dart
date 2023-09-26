// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ReschuleRequestSheet extends StatefulWidget {
  final Function handlerOk;
  const ReschuleRequestSheet({
    Key? key,
    required this.handlerOk,
  }) : super(key: key);

  @override
  State<ReschuleRequestSheet> createState() => _ReschuleRequestSheetState();
}

class _ReschuleRequestSheetState extends State<ReschuleRequestSheet> {
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCancelBtn(context),
                    _buildDoneBtn(context),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  use24hFormat: true,
                  backgroundColor: Colors.white,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (value) {
                    setState(() {
                      selectedDate = value;
                    });
                  },
                ),
              ),
            ],
          );
  }
  TextButton _buildDoneBtn(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedDate ??= DateTime.now();
        });
        widget.handlerOk(selectedDate);

        Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 16,
        ),
      ),
      child: Text(AppLocalizations.of(context)!.ok),
    );
  }

  TextButton _buildCancelBtn(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 16,
        ),
      ),
      child: Text(
        AppLocalizations.of(context)!.cancel,
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}
