import 'package:cloud_firestore/cloud_firestore.dart';

class EarnedBadge {
  final String badgeId;
  final DateTime earnedAt;

  EarnedBadge({required this.badgeId, required this.earnedAt});

  factory EarnedBadge.fromMap(Map<String, dynamic> data) {
    return EarnedBadge(
      badgeId: data['badgeId'],
      earnedAt: (data['earnedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'badgeId': badgeId,
      'earnedAt': earnedAt,
    };
  }
}
