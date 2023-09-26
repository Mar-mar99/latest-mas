import 'package:flutter/material.dart';

import '../widgets/app_text.dart';

class InvoiceItem extends StatelessWidget {
 final String title;
  final dynamic subTitle;
  bool isLast;
  Color colorSubTitle;
  InvoiceItem({
    Key? key,
    required this.title,
    required this.subTitle,
    this.colorSubTitle = Colors.black,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              AppText(
                title,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              const Spacer(),
              AppText(
                '$subTitle',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: colorSubTitle,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        if (!isLast) const Divider(),
      ],
    );
  }
}
