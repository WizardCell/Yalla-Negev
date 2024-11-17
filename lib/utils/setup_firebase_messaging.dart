import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/generated/l10n.dart';
import 'package:yalla_negev/navigation/navigation_service.dart';
import 'package:yalla_negev/providers/navigation_provider.dart';
import 'package:overlay_support/overlay_support.dart';

import '../app/yalla_negev_app_welcome.dart';
import '../ui/widgets/app_bottom_navigation_bar.dart';

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yalla_negev/utils/globals.dart';

void changeDataBaseField() async {
  final QuerySnapshot<Map<String, dynamic>> snapshot =
      await usersCollection.get();

  final WriteBatch batch = database.batch();
  final Random random = Random();

  for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
    final Map<String, dynamic> data = doc.data();
    data['points'] =
        random.nextInt(100); // Generate a random number between 0 and 99
    batch.update(doc.reference, {'points': data['points']});
  }

  await batch.commit();
  print('Points changed successfully');
}

void setupFirebaseMessaging(BuildContext context) {
  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

  final onMessageStream = FirebaseMessaging.onMessage.asBroadcastStream();
  final processedMessageIds = <String>{};
  

  onMessageStream.listen((RemoteMessage message) {
    final betterContext = NavigatorService.navigatorKey.currentState!.overlay!.context;
    var l10n = S.of(betterContext);

    print('Message data: ${message.data}');
    if (message.data['type'] == 'survey') {
      if (processedMessageIds.contains(message.messageId)) {
        return;
      }
      if (MyYallaNegevAppWelcome.lastForegroundMessageTime == null ||
          DateTime.now().difference(
                  MyYallaNegevAppWelcome.lastForegroundMessageTime!) >
              const Duration(seconds: 5)) {
        MyYallaNegevAppWelcome.lastForegroundMessageTime = DateTime.now();
        showSimpleNotification(
          Text(message.notification?.body ??
              'A new survey was added. Participate now to share your opinion!'),
          background: Colors.green,
          duration: const Duration(seconds: 4),
          slideDismissDirection: DismissDirection.vertical,
        );
        processedMessageIds.add(message.messageId!);
      }
    } else if (message.data['type'] == 'broadcast') {
      // Show a dialog with the message
      showDialog(
        context: betterContext,
        builder: (context) {
          return AlertDialog(
            title: Text(message.notification!.title!),
            content: Text(message.notification!.body!),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(l10n.ok),
              ),
            ],
          );
        },
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Message data: ${message.data}');
    if (message.data['type'] == 'survey') {
      final navigationProvider =
          Provider.of<NavigationProvider>(context, listen: false);
      navigationProvider.selectTab(BottomBarEnum.surveys);
    }
  });
}

Future<void> _backgroundHandler(RemoteMessage msg) async {
  await Firebase.initializeApp();
  print("Handling a background msg: ${msg.messageId}");
}
