import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'my_yalla_negev_app.dart';

class YallaNegevApp extends StatelessWidget {
  const YallaNegevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text(snapshot.error.toString(),
                      textDirection: TextDirection.ltr)));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          // Request permission for push notifications
          FirebaseMessaging.instance
              .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          )
              .then((_) {
            // Subscribe to topic after permission is granted
            FirebaseMessaging.instance.subscribeToTopic('surveys');
            FirebaseMessaging.instance.subscribeToTopic('broadcast');
          });

          return const MyYallaNegevApp();
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
