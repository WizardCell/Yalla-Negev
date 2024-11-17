import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yalla_negev/providers/language_provider.dart';
import 'package:yalla_negev/utils/locale_helper.dart';
import '../gamification/earned_badge.dart';

import 'user_role.dart';

export 'user_role.dart';

// Firebase object model for user data
class UserData {
  String id;
  String name;
  String displayName;
  final String email;
  int points;
  String? pictureUrl;
  UserRole role;
  final DateTime? joinDate;
  bool? prefersDarkTheme;
  String? language;
  List<EarnedBadge>? earnedBadges;
  bool welcomeRewardGiven;

  UserData({
    required this.id,
    required this.name,
    required this.displayName,
    required this.email,
    this.points = 0,
    this.pictureUrl,
    this.role = UserRole.none,
    this.joinDate,
    this.prefersDarkTheme,
    this.language,
    this.earnedBadges = const [],
    this.welcomeRewardGiven = false,
  });

  Map<String, dynamic> toFirebaseObject() {
    return {
      'name': name,
      'displayName': displayName,
      'email': email,
      'points': points,
      'pictureUrl': pictureUrl,
      'role': role.index, // Convert enum to its index
      'joinDate': joinDate
          ?.millisecondsSinceEpoch, // Convert DateTime to Unix timestamp
      'prefersDarkTheme': prefersDarkTheme,
      'language': language,
      'earnedBadges': earnedBadges?.map((badge) => badge.toMap()).toList(),
      'welcomeRewardGiven': welcomeRewardGiven,
    };
  }

  factory UserData.fromFirebaseObject(Map<String, dynamic>? map, String id) {
    if (map == null || map.isEmpty) {
      return UserData(
          id: '', name: '', displayName: '', email: ''); // Return empty object
    }

    return UserData(
      id: id,
      name: map['name'] as String,
      displayName: map['displayName'] as String,
      email: map['email'] as String,
      points: map['points'] as int? ?? 0,
      pictureUrl: map['pictureUrl'] as String?,
      role: UserRole.values[map['role'] as int? ?? 0], // Convert index to enum
      joinDate: map['joinDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['joinDate'] as int)
          : null, // Convert Unix timestamp to DateTime
      prefersDarkTheme: map['prefersDarkTheme'] as bool? ?? false,
      language: map['language'] as String? ??
          getLanguageFromSupportedLocale(defaultLocale),
      earnedBadges: (map['earnedBadges'] as List<dynamic>?)
              ?.map((badge) => EarnedBadge.fromMap(badge as Map<String, dynamic>))
              .toList() ??
          [],
      welcomeRewardGiven: map['welcomeRewardGiven'] as bool? ?? false,
    );
  }

  factory UserData.fromFirestore(QueryDocumentSnapshot doc) {
    return UserData
        .fromFirebaseObject(doc.data() as Map<String, dynamic>?, doc.id);
  }

  static UserData empty() {
    return UserData(id: '', name: '', displayName: '', email: '');
  }
}
