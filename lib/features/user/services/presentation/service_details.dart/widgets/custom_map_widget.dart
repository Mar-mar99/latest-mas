// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import '../../../../../../core/ui/widgets/app_text.dart';

class CustomMapWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color colorIcon;
  const CustomMapWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
     required this.colorIcon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(
              8,
            ),
          ),
          width: 30,
          height: 38,
          child: Icon(
            icon,
            size: 16,
            color:Colors.white,
          ),
        ),
       const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            boxShadow: const <BoxShadow> [
              BoxShadow(
                  color: Colors.white,
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: Offset.zero),
            ],
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(20),
          ),
          child: AppText(
            title,
            color:Colors.blue
          ),
        )
      ],
    );
  }
}
