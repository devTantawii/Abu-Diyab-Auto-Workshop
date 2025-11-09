import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FcmApi {
  final firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    // 1. طلب الإذن من المستخدم
    await firebaseMessaging.requestPermission();

    // 2. الحصول على FCM token
    final fcmToken = await firebaseMessaging.getToken();
    print("🔑 FCM Token: $fcmToken");

    // 3. تهيئة الإشعارات المحلية
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // 4. إعداد استقبال الإشعارات في الخلفية
    FirebaseMessaging.onBackgroundMessage(handleBackgroundFcm);

    // 5. استقبال الإشعارات أثناء عمل التطبيق (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Received message in foreground!");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");

      // عرض إشعار محلي عند استقبال رسالة أثناء فتح التطبيق
      if (message.notification != null) {
        showLocalNotification(
          message.notification!.title ?? 'No title',
          message.notification!.body ?? 'No body',
        );
      }
    });
  }

  // دالة عرض الإشعار المحلي
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

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}

// دالة الخلفية
Future<void> handleBackgroundFcm(RemoteMessage message) async {
  print("🌙🌙🌙🌙🌙 Background Message:");
  print("🌙🌙🌙Title: ${message.notification?.title}");
  print("🌙🌙🌙🌙🌙Body: ${message.notification?.body}");
}
