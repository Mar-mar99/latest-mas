import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<File?> pickImage(BuildContext context, ImageSource source) async {
  try {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return null;
    final imageTemp = File(image.path);
    return imageTemp;
  } on Exception {
    ToastUtils.showErrorToastMessage(
      'Something wrong has happend, try again',
    );
  }
  return null;
}

Future showPickerImageSheet(BuildContext context) async {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
                leading: const Icon(Icons.camera_alt_rounded),
                title: Text(AppLocalizations.of(context)!.cameraLabel),
              ),
              ListTile(
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                leading: const Icon(Icons.image),
                title: Text(AppLocalizations.of(context)!.galleryLabel),
              ),
            ],
          ),
        ],
      );
    },
  );
}
