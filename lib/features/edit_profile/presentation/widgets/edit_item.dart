// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../../core/ui/widgets/app_text.dart';

class EditItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTapHandler;
  final bool showValue;
  const EditItem(
      {Key? key,
      required this.label,
      required this.value,
      required this.onTapHandler,
      this.showValue = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapHandler();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                label,
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              if (showValue) ...[
                const SizedBox(
                  height: 5,
                ),
                AppText(
                  value,
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ]
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              onTapHandler();
            },
            child: Icon(
              EvaIcons.editOutline,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
