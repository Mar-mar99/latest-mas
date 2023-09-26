// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:masbar/core/ui/widgets/custom_item.dart';

import '../app_text.dart';

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const ProfileItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomItem(
      startIcon: icon,
      startIconSize: 30,
      startIconColor: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppText(
            text,
            fontWeight: FontWeight.w800,
          ),
        ],
      ),
      onTap: () {
        onTap();
      },
    );
  }
}
