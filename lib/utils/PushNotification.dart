import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotifications{
  static final firebaseMessaging=FirebaseMessaging.instance;

  static Future init() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true
    );

    firebaseMessaging..setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );


    final token = await firebaseMessaging.getToken();
    print(token);

  }
}
