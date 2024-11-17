import 'package:cloud_functions/cloud_functions.dart';

class NotificationManager {
  static Future<void> sendNotification(
      String title, String body, String imageUrl) async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('sendNotificationToAll');
    final response = await callable.call(<String, dynamic>{
      'title': title,
      'body': body,
      'image': imageUrl,
    });

    if (response.data['success'] != true) {
      throw Exception('Failed to send notification');
    }
  }

  static Future<String> getDeletionInstructions() async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('deleteUser');
    final response = await callable.call();

    if (response.data is String) {
      return response.data;
    } else {
      throw Exception('Failed to get deletion instructions');
    }
  }
}
