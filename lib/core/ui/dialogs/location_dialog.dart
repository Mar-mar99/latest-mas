import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import 'package:permission_handler/permission_handler.dart';
showLocationDialogDialog(
  BuildContext context,
  String title
) async{
 return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            const Icon(
              EvaIcons.alertCircleOutline,
              color: Colors.green,
              size: 65,
            ),
            const SizedBox(
              height: 24,
            ),
            AppText(
              title,
              type: TextType.medium,
            ),
            const SizedBox(
              height: 24,
            ),
            AppButton(
              title: "Allow",
              buttonColor: ButtonColor.green,
              onTap: () async {
                Map<Permission, PermissionStatus> statuses = await [
                  Permission.location,
                ].request();


                Navigator.pop(context,statuses[Permission.location]);
              },
            ),
            const SizedBox(
              height: 14,
            ),
            AppButton(
              title: "Deny",
              buttonColor: ButtonColor.transparentBorderPrimary,
              onTap: () async {
                Navigator.pop(context,PermissionStatus.denied);
              },
            )
          ],
        ),
      ),
    )
  );

}
