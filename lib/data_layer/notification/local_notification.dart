import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static FlutterLocalNotificationsPlugin notification =
      FlutterLocalNotificationsPlugin();
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();
  void init() {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    final AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel('0', 'hamed', showBadge: false);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    notification.initialize(initializationSettings);
  }

  static Future notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel Id 4',
        'channel name',
        onlyAlertOnce: true,
        colorized: true,
        playSound: false,
        ongoing: true,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static void showNotification(
    String title,
    String body,
    String payLoad,
  ) async {
    await notification.show(
      0,
      title,
      body,
      await notificationDetails(),
      payload: payLoad,
    );
  }
}

class LocalNotification {}
