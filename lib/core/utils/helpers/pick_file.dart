import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';
import 'package:permission_handler/permission_handler.dart';

Future<File?> getPickedFile() async {
  await [
    Permission.storage,
  ].request();
  try {
    final selectedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );

    if (selectedFile != null) {
      File file = File(selectedFile.files.single.path ?? "");
      return file;
    }
    return null;
  } on Exception {
    ToastUtils.showErrorToastMessage('Something wrong has happend, try again');
  }
}
