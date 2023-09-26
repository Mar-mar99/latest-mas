import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/dialogs/location_dialog.dart';
import '../enums/enums.dart';

Future<PermissionStatus> requestLocationPermission(
    BuildContext context, TypeAuth auth) async {
  var locationPermission = Permission.location;
  PermissionStatus permissionStatus = await locationPermission.status;
  String title = '';
  switch (auth) {
    case TypeAuth.user:
      title = AppLocalizations.of(context)!.messageLocationUserDialog;
      break;
    case TypeAuth.company:
      break;
    case TypeAuth.provider:
      title = AppLocalizations.of(context)!.messageLocationProviderDialog;
      break;
  }
  if (!permissionStatus.isGranted) {
    PermissionStatus status = await showLocationDialogDialog(context, title);
    return status;
  } else {
    return PermissionStatus.granted;
  }
}
