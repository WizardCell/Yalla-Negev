import 'package:yalla_negev/models/surveys/localized_text.dart';

class PointsTransaction {
  final String? id;
  final String userId;
  final int points;
  final LocalizedText description;
  final DateTime ts;

  PointsTransaction({
    required this.id,
    required this.userId,
    required this.points,
    required this.description,
    required this.ts,
  });

  // id should be taken from docId
  factory PointsTransaction.fromMap(String id, Map<String, dynamic> data) {
    return PointsTransaction(
      id: id,
      userId: data['userId'],
      points: data['points'],
      description: LocalizedText.fromMap(data['description']),
      ts: data['ts'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'points': points,
      'description': description.toMap(),
      'ts': ts,
    };
  }

  PointsTransaction copyWith({
    String? id,
    String? userId,
    int? points,
    LocalizedText? description,
    DateTime? ts,
  }) {
    return PointsTransaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      points: points ?? this.points,
      description: description ?? this.description,
      ts: ts ?? this.ts,
    );
  }

  static newTransaction(String userId, int points, LocalizedText description) {
    return PointsTransaction(
      id: null,
      userId: userId,
      points: points,
      description: description,
      ts: DateTime.now(),
    );
  }
}