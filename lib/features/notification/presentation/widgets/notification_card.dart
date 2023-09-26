import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:masbar/core/ui/widgets/app_dialog.dart';
import 'package:masbar/features/notification/domain/entities/notification_entity.dart';

import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/ui/widgets/app_text.dart';
import '../../../../core/utils/helpers/helpers.dart';
import '../../../auth/accounts/domain/repositories/auth_repo.dart';
import '../bloc/delete_notification_bloc.dart';
import '../helpers/notification_helper.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final String type;

  const NotificationCard({
    Key? key,
   required this.notification,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NotificationHelper.openNotification(notification: notification);
        // NotificationNavigator.openNotification(
        //     notificationsObject: notification!,
        //     userData: Provider.of<AuthProvider>(context, listen: false).userData!,
        //     cc: context);

        // model.readNotification(  type: type, id: notification?.id ?? -1);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ServicesDetailsPage(
        //       serviceId: notification?.requestId ?? -1,
        //     ),
        //   ),
        // );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.readByUser == 0
              ? Colors.grey.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: notification.readByUser == 0
                  ? Colors.white
                  : Colors.grey[200]!,
              offset: const Offset(0, 0),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 24,
                  width: 24,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8)),
                  child: Image.asset(
                    (notification.type == 'new_message')
                        ? 'assets/message.png'
                        : 'assets/images/pell.png',
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (notification.type != null)
                            AppText(
                              NotificationHelper.getTitle(
                                notification.type!,
                              ),

                              fontSize: 16,
                            ),
                          AppText(
                            notification.notification ?? "",
                            textAlign: TextAlign.left,
                            fontSize: 14,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'delete') {
                      _showDeleteDialog(context);
                    }
                  },
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_horiz),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete,
                              color: Theme.of(context).primaryColor),
                          title: Text(AppLocalizations.of(context)!.delete),
                        ))
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) {
        return DialogItem(
          icon: Icon(FontAwesomeIcons.trash,
              color: Theme.of(context).primaryColor),
          title: AppLocalizations.of(context)!.deleteNotificationTitle,
          paragraph: AppLocalizations.of(context)!.deleteNotificationPara,
          nextButtonText: AppLocalizations.of(context)!.delete,
          cancelButtonText: AppLocalizations.of(context)!.cancel,
          cancelButtonFunction: () {
            Navigator.pop(context);
          },
          nextButtonFunction: () {
            Navigator.pop(context);
            BlocProvider.of<DeleteNotificationBloc>(context).add(DeleteEvent(
                typeAuth: Helpers.getUserTypeEnum(
                    context.read<AuthRepo>().getUserData()!.type!),
                id: notification.id!));
          },
        );
      },
    );
  }
}
