import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:masbar/core/utils/enums/enums.dart';

import 'package:masbar/features/notification/data/model/notification_model.dart';
import 'package:masbar/features/notification/domain/entities/notification_entity.dart';
import 'package:uuid/uuid.dart';

import 'config/routes/app_router.dart';
import 'core/locator/service_locator.dart';
import 'core/utils/services/notification_service.dart';
import 'core/utils/services/shared_preferences.dart';
import 'features/app/my_app.dart';
import 'features/auth/accounts/data/repositories/auth_repo_impl.dart';
import 'features/notification/presentation/helpers/notification_helper.dart';
import 'package:flutter_callkeep_custome/flutter_callkeep.dart';

import 'features/provider/homepage/presentation/coming_request/screen/new_request_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

NotificationServices notificationServices = NotificationServices();
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.notification != null) {
    print(
        '_firebaseMessagingBackgroundHandler ${message.notification!.toString()}');
  }
  print('_firebaseMessagingBackgroundHandler ${message.data.toString()}');

  if (message.data['TYPE'] == 'NEW REQUEST' ||
      message.data['TYPE'] == 'INCOMING_REQUEST_BUSY') {
    final config = CallKeepIncomingConfig(
        uuid: Uuid().v4(),
        callerName: 'New Request',
        contentTitle: 'Masbar',
        appName: 'Masbar',
        // avatar: 'app_icon',
        handle: 'Masbar - New Request',
        hasVideo: false,
        // duration: 30000,
        acceptText: 'Details',
        declineText: 'Decline',
        missedCallText: 'Missed Request',
        callBackText: 'Call back',
        extra: <String, dynamic>{
          'id': message.data['request_id'],
          'isBusy': message.data['TYPE'] == 'INCOMING_REQUEST_BUSY'
        },
        // headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
        androidConfig: CallKeepAndroidConfig(
          // logo: "app_icon",
          showCallBackAction: true,
          showMissedCallNotification: true,
          //  notificationIcon: 'app_icon',
          ringtoneFileName: 'ring_call',
          accentColor: '#f55442',
          //  backgroundUrl: 'assets/images/logo.jpg',
          incomingCallNotificationChannelName: 'Incoming Calls11',
          missedCallNotificationChannelName: 'Missed Calls11',
        ),
        iosConfig: CallKeepIosConfig());
    await CallKeep.instance.displayIncomingCall(config);
  } else {
    await notificationServices.showBasicNotification(
      id: message.data.hashCode,
      title: NotificationHelper.getTitle(
        message.data['TYPE'],
      ),
      body: message.data['body'],
      payload: json.encode(
        message.data,
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  notificationServices.requestNotificationPermission();
  notificationServices.forgroundMessageForIos();
  await notificationServices.firebaseInit();
  notificationServices.initLocalNotifications();
  notificationServices.setupInteractMessage();
  listenToNotification();

  await dotenv.load(fileName: "assets/config/.env");
  await PreferenceUtils.init();

  HttpOverrides.global = MyHttpOverrides();

  CallKeep.instance.onEvent.listen((event) async {
    if (event == null) return;
    switch (event.type) {
      case CallKeepEventType.callAccept:
        final data = event.data as CallKeepCallData;
        print('call answered: ${data.toMap()}');
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => NewRequestScreen(
              id: int.parse(data.toMap()['extra']['id']),
              requestType: (data.toMap()['extra']['isBusy'] as bool)
                  ? ProviderStatus.busy
                  : ProviderStatus.online,
            ),
          ),
        );
        break;

      case CallKeepEventType.callDecline:
        break;
      default:
        break;
    }
  });

  await setupLocator();

  runApp(
    MyApp(
      appRouter: AppRouter(),
      authRepo: AuthRepoImpl(),
    ),
  );
}

void listenToNotification() {
  notificationServices.onNotifications.stream.listen((payload) {
    if (payload != null) {
      print('listening from main');
      NotificationEntity notificationEntity =
          NotificationModel.fromJson(payload);
      NotificationHelper.openNotification(notification: notificationEntity);
    }
  });
}
