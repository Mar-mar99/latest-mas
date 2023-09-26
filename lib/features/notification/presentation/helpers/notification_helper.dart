import 'package:flutter/material.dart';
import 'package:masbar/features/notification/domain/entities/notification_entity.dart';

import '../../../../core/utils/enums/enums.dart';
import '../../../app/my_app.dart';
import '../../../app_wrapper/app_wrapper.dart';
import '../../../provider/homepage/presentation/coming_request/screen/new_request_screen.dart';
import '../../../user/services/presentation/new_schedule/screens/new_schedule_screen.dart';

class NotificationHelper {
  static void openNotification({
    required NotificationEntity notification,
  }) async {
    print('type ${notification.type}');
    switch (notification.type) {
      case 'NEW REQUEST':
     
        await navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => NewRequestScreen(
                requestType: ProviderStatus.online,
                id: notification.requestId!),
          ),
        );
        break;
      case 'INCOMING_REQUEST_BUSY':
        await navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => NewRequestScreen(
                requestType: ProviderStatus.busy, id: notification.requestId!),
          ),
        );
        break;
      case 'REQUEST_ACCEPTED':
      case 'PROVIDER_ARRIVED':
      case 'SERVICE_STARTED':
      case 'SERVICE_COMPLETED':
      case 'REQUEST_CANCELED_BY_PROVIDER':
      case 'PROVIDER_NOT_AVAILABLE':
    // Navigator.push(
        //   di<NavigationService>().navigatorKey.currentContext!,
        //   MaterialPageRoute(
        //     builder: (context) => ServicesDetailsPage(
        //       serviceId: notificationsObject.requestId ?? -1,
        //     ),
        //   ),
        // );
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => AppWrapper(),
          ),
        );
        break;

      case 'PAYMENT_RECEIVED':
      case 'MONEY_CHARGED':
      case 'MONEY_DEDUCTION':

        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => AppWrapper(),
          ),
        );

        /// check if for request open service details else open walet
        break;
      case 'REQUEST_CANCELED_BY_USER':

        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => AppWrapper(),
          ),
        );
        // Navigator.push(
        //   di<NavigationService>().navigatorKey.currentContext!,
        //   MaterialPageRoute(
        //     builder: (context) => DetailsServicesRecordProvider(
        //       id: (notificationsObject.requestId?? '-1').toString() ,
        //     ),
        //   ),
        // );
        break;

      /// open service details for provider

      case 'REQUEST_SCHEDULED':
      case 'SCHEDULED_REQUEST_ACCEPTED':

        break;
      case 'INCOMING_REQUEST':

        break;

      case 'DOCUMENT_VERIFIED':
      case 'DOCUMENT_NOT_VERIFIED':

        break;
      case 'SCHEDULE_REMINDER':
      case 'USER_ACCEPTED_SCHEDULE':
      case 'PROVIDER_SUGGEST_TIME':
        await navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => NewScheduleScreen(
              id: notification.requestId!,
            ),
          ),
        );
        break;
      case 'REQUEST_REJECTED_BY_PROVIDER':
      case 'STOP_RINGING':
        break;
    }
  }

  static String getTitle(String type) {
    String title = '';
    switch (type) {
      case 'NEW REQUEST':
      case 'NEW INCOMING_REQUEST_BUSY':
        return 'New Request';

      case 'REQUEST_ACCEPTED':
        title = 'Request Accepted';
        break;
      case 'REQUEST_SCHEDULED':
        title = 'Request Scheduled';
        break;
      case 'MONEY_CHARGED':
        title = 'Charged Money';
        break;
      case 'MONEY_DEDUCTION':
        title = 'Money Discount';
        break;
      case 'REQUEST_CANCELED_BY_PROVIDER':
        title = 'Request Canceled by Provider';
        break;
      case 'PROVIDER_NOT_AVAILABLE':
        title = 'Provider not available';
        break;
      case 'PROVIDER_ARRIVED':
        title = 'Provider Arrived';
        break;
      case 'SERVICE_STARTED':
        title = 'Service Started';
        break;
      case 'SERVICE_COMPLETED':
        title = 'Service Completed';
        break;
      case 'PAYMENT_RECEIVED':
        title = 'Payment Received';
        break;
      case 'INCOMING_REQUEST':
        title = 'Incoming Request';
        break;
      case 'REQUEST_CANCELED_BY_USER':
        title = 'Request Canceled by User';
        break;
      case 'DOCUMENT_VERIFIED':
        title = 'Document Verified';
        break;
      case 'DOCUMENT_NOT_VERIFIED':
        title = 'Document Not Verified';
        break;
      case 'SCHEDULE_REMINDER':
        title = 'Schedule Reminder';
        break;
      case 'USER_ACCEPTED_SCHEDULE':
        title = 'The user has accepted the schedule';
        break;
      case 'PROVIDER_SUGGEST_TIME':
        title = 'Provider has suggested new time';
        break;
      case 'REQUEST_REJECTED_BY_PROVIDER':
        title = 'The provider has rejected the request';
        break;
      case 'STOP_RINGING':
        title = 'Stop Ringing';
        break;
    }
    return title;
  }
}
