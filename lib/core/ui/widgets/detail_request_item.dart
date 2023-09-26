import 'package:flutter/material.dart';

import 'app_text.dart';

class DetailRequestItem extends StatelessWidget {
  final String title;
  final String subTitle;
  bool isLast;
  DetailRequestItem({
    Key? key,
    required this.title,
    required this.subTitle,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        AppText(
          title,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        const SizedBox(
          height: 6,
        ),
        AppText(
          subTitle,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        const SizedBox(
          height: 6,
        ),
        if (!isLast) const Divider(),
      ],
    );
  }
}
