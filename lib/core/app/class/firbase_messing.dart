import 'package:ecommerce_app/core/app/screen/notivigation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Firbasnotivigation {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<void> inNotivigation(context) async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    String? tokin = await messaging.getToken();
    print(" =======================================$tokin");
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked: ${message.notification?.title}');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) =>
                  Notivigation(messige: "${message.notification?.title}"),
        ),
      );
    });
  }
}
