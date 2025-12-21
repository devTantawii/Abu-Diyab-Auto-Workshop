import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FcmApi {
  final firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();

    try {
      final fcmToken = await firebaseMessaging.getToken();
      if (fcmToken != null) {
        print("🔑 FCM Token: $fcmToken");
      } else {
        print("⚠️ APNS token not available (probably running on simulator)");
      }
    } catch (e) {
      print("⚠️ Error getting APNS token: $e");
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onBackgroundMessage(handleBackgroundFcm);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {


      if (message.notification != null) {
        showLocalNotification(
          message.notification!.title ?? 'No title',
          message.notification!.body ?? 'No body',
        );
      }
    });
  }

  Future<void> showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'default_channel_id',
          'Default Channel',
          channelDescription: 'Channel for foreground notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}

Future<void> handleBackgroundFcm(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
}
