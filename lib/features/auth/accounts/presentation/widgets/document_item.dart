
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:masbar/core/ui/widgets/app_text.dart';

class DocumentItem extends StatelessWidget {
  final VoidCallback onRemoveHandler;
  final String name;
  final File image;
  const DocumentItem({
    Key? key,
    required this.onRemoveHandler,
    required this.name,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white70),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).dividerColor),
      child: Row(
        children: [
         SizedBox(
          height: 50,
          width:50,
          child: Image.file(image,fit: BoxFit.cover,)),
          const SizedBox(
            width: 15,
          ),
          Expanded(child: AppText(name)),
          InkWell(
            onTap: () {
              onRemoveHandler();
            },
            child: Icon(
              Icons.cancel,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
