import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Настройки для Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Настройки для iOS
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );
  }

  static void onNotificationTap(NotificationResponse response) {
    // Обработка нажатия на уведомление
    print('Уведомление нажато: ${response.payload}');
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    final notificationDetails = NotificationDetails(
      iOS: DarwinNotificationDetails(),
    );
    await NotificationService.notifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: 'easy_paint',
    );
  }
}
