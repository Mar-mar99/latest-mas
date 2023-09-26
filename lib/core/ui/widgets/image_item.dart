// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import '../../utils/helpers/helpers.dart';

class ImageItem extends StatelessWidget {
  final String? image;
  final File? fileImage;
  final bool isFile;
  final bool showCancel;
  final VoidCallback? handler;
  const ImageItem({
    Key? key,
    this.image,
    this.fileImage,
    required this.isFile,
    this.showCancel = false,
    this.handler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 32 - 8) / 2,
      height: (MediaQuery.of(context).size.width - 32 - 8) / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              spreadRadius: -0.2,
              offset: Offset(0, 4.0),
              blurRadius: 11.0)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: isFile
                  ? Image.file(
                      fileImage!,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      Helpers.getImage(image!),
                      fit: BoxFit.cover,
                    ),
            ),
            if (showCancel)
              Positioned(
                top: 8.0,
                right: 8.0,
                child: InkWell(
                  onTap: handler,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        FeatherIcons.x,
                        size: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
