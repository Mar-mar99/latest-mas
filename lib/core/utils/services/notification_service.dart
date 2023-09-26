import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/notification/domain/entities/notification_entity.dart';
import 'package:rxdart/rxdart.dart';
import '../../../features/app/my_app.dart';
import '../../../features/notification/data/model/notification_model.dart';
import '../../../features/notification/presentation/helpers/notification_helper.dart';
import '../../../features/provider/homepage/presentation/coming_request/screen/new_request_screen.dart';

class NotificationServices {
  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final onNotifications = BehaviorSubject<Map<String, dynamic>?>();
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'masbar_channel2',
    'masbar_channel2',
    importance: Importance.max,
    showBadge: false,
    playSound: true,
    enableLights: true,
    sound: RawResourceAndroidNotificationSound('ring_call'),
  );

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: false,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  Future forgroundMessageForIos() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future firebaseInit() async {
    // Listneing to the foreground messages
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print("notifications type:${message.data['TYPE']}");
        print('count:${android!.count}');
        print('data:${message.data.toString()}');
      }

      if (Platform.isIOS) {
        forgroundMessageForIos();
      }

      if (Platform.isAndroid) {
        if (message.data['TYPE'] == 'NEW REQUEST') {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => NewRequestScreen(
                id: int.parse(
                  message.data['request_id'],
                ),
                requestType: message.data['TYPE'] == 'INCOMING_REQUEST_BUSY'
                    ? ProviderStatus.busy
                    : ProviderStatus.online,
              ),
            ),
          );
        } else {
          print('front');
          showBasicNotification(
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
    });
  }

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications({bool isSchedule = false}) async {
    var androidInitializationSettings = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload) {
        // handle interaction when app is active for android
        print('onDidReceiveNotificationResponse ${payload.payload}');
        Map<String, dynamic> data = jsonDecode(payload.payload!);
        onNotifications.add(data);
      },
    );
  }

  //handle tap interaction on notification when app is in background or terminated
  Future<void> setupInteractMessage() async {
    // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print('interact 1');
      NotificationEntity notificationEntity =
          NotificationModel.fromJson(initialMessage.data);
      NotificationHelper.openNotification(notification: notificationEntity);
      print('done interacting');
    }

    //when app in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('interact 2');
      onNotifications.add(event.data);
    });
  }

  // function to show visible notification when app is active
  Future<void> showBasicNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'Basic Channel',
      'Normal Notification',
      importance: Importance.max,
      showBadge: false,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      sound: channel.sound,
      enableLights: true,
      audioAttributesUsage: AudioAttributesUsage.notification,
      category: AndroidNotificationCategory.alarm,
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(
      Duration.zero,
      () {
        _flutterLocalNotificationsPlugin.show(
          id,
          title,
          body,
          notificationDetails,
          payload: payload,
        );
      },
    );
  }

  Future<void> showNewRquestNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'masbar_channel2',
      'masbar_channel2',
      importance: Importance.max,
      showBadge: false,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('ring_call'),
    );
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      fullScreenIntent: true,
      ticker: 'ticker',
      sound: channel.sound,
      enableLights: true,
      audioAttributesUsage: AudioAttributesUsage.voiceCommunication,
      category: AndroidNotificationCategory.call,
      actions: [const AndroidNotificationAction("id", "Check it out")],
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(
      Duration.zero,
      () {
        _flutterLocalNotificationsPlugin.show(
          id,
          title,
          body,
          notificationDetails,
          payload: payload,
        );
      },
    );
  }
}
