import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yalla_negev/providers/user_provider.dart';

import '../models/gamification.dart';
import '../models/surveys/localized_text.dart';
import '../models/users.dart';
import '../utils/globals.dart';

class BonusProvider extends ChangeNotifier {
  AuthRepository authRepository;

  int _badgesCollected = 0;
  int _totalBadges = 0;
  bool _dataFetched = false;

  int _leaderboardPosition = 0;
  List<UserData> _leaderboardUsers = [];
  bool _isLeaderboardLoading = false;

  BonusProvider({required this.authRepository});

  int get points => authRepository.getUserPoints();
  int get leaderboardPosition => _leaderboardPosition;
  int get badgesCollected => _badgesCollected;
  int get totalBadges => _totalBadges;
  bool get dataFetched => _dataFetched;
  List<UserData> get leaderboardUsers => _leaderboardUsers;
  bool get isLeaderboardLoading => _isLeaderboardLoading;

  void updateAuthRepository(AuthRepository authRepository) {
    this.authRepository = authRepository;
    notifyListeners();
  }

  int getPositionByUserId(String userId) {
    return _leaderboardUsers.indexWhere((user) => user.id == userId) + 1;
  }

  int getPointsByUserId(String userId) {
    return _leaderboardUsers.firstWhere((user) => user.id == userId).points;
  }

  Future<void> fetchLeaderboard() async {
    _isLeaderboardLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await usersCollection
          .orderBy('points', descending: true)
          .get();

      _leaderboardUsers = snapshot.docs.map((doc) {
        return UserData.fromFirestore(doc);
      }).toList();

      String userId = authRepository.uid;
      _leaderboardPosition =
          _leaderboardUsers.indexWhere((user) => user.id == userId) + 1;

      notifyListeners();
    } catch (e) {
      print('Error fetching leaderboard: $e');
    } finally {
      _isLeaderboardLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBonusData({bool isForce = false}) async {
    if (!_dataFetched || isForce) {
      try {
        await authRepository.populateUserData();

        await fetchLeaderboard();

        _totalBadges = await _fetchTotalBadgesCount();
        _badgesCollected = await _fetchCollectedBadgesCount();

        await checkAndAwardBadges();
        _dataFetched = true;
        notifyListeners();
      } catch (e) {
        print('Error fetching bonus data: $e');
      }
    }
  }

  Future<int> _fetchTotalBadgesCount() async {
    try {
      var badgesSnapshot = await badgesCollection.get();
      return badgesSnapshot.size;
    } catch (e) {
      print('Error fetching total badges count: $e');
      return 0;
    }
  }

  Future<int> _fetchCollectedBadgesCount() async {
    try {
      List<EarnedBadge> earnedBadges = await fetchEarnedBadges();
      return earnedBadges.length;
    } catch (e) {
      print('Error fetching collected badges count: $e');
      return 0;
    }
  }

  Future<List<PointsTransaction>> fetchPointsHistory() async {
    var transactionDocs = await pointsTransactionsCollection
        .where('userId', isEqualTo: authRepository.uid)
        .orderBy('ts', descending: true)
        .get();

    return transactionDocs.docs.map((doc) {
      return PointsTransaction.fromMap(doc.id, doc.data());
    }).toList();
  }

  Future<void> addPointsTransaction(
      LocalizedText description, int points) async {
    try {
      PointsTransaction newTransaction = PointsTransaction.newTransaction(
          authRepository.uid, points, description);

      pointsTransactionsCollection.add(newTransaction.toMap());
      await authRepository.updateUserPoints(authRepository.userData!.points + points);

      notifyListeners();
    } catch (e) {
      print('Failed to add points transaction: $e');
    }
  }

  Future<List<YallaBadge>> fetchAvailableBadges(
      {String? conditionType}) async {

    if(conditionType == null) {
      var badgesSnapshot = await badgesCollection.get();
      return badgesSnapshot.docs.map((doc) {
        return YallaBadge.fromMap(doc.id, doc.data());
      }).toList();
    } else {
      var badgesSnapshot = await badgesCollection
          .where('condition.conditionType', isEqualTo: conditionType).get();
      return badgesSnapshot.docs.map((doc) {
        return YallaBadge.fromMap(doc.id, doc.data());
      }).toList();
    }
  }

  Future<void> checkAndAwardBadges() async {
    if (authRepository.userData == null) {
      print('User data not loaded. Cannot award badges.');
      return;
    }

    List<YallaBadge> availableBadges = await fetchAvailableBadges();
    List<EarnedBadge> earnedBadges = await fetchEarnedBadges();
    Set<String> earnedBadgeIds = earnedBadges.map((badge) => badge.badgeId).toSet();

    for (YallaBadge badge in availableBadges) {
      if (earnedBadgeIds.contains(badge.id)) continue;

      bool shouldAward = await _checkBadgeCondition(badge.condition) ?? false;
      if (shouldAward) {
        await _awardBadge(badge.id);
      }
    }
  }

  Future<List<EarnedBadge>> fetchEarnedBadges() async {
    try {
      await authRepository.populateUserData();
      return authRepository.userData?.earnedBadges ?? [];
    } catch (e) {
      print('Error fetching earned badges: $e');
      return [];
    }
  }

  Future<bool?> _checkBadgeCondition(BadgeCondition condition) async {
    switch (condition.conditionType) {
      case 'manual':
        return false;
      case 'surveysThreshold':
        var completedSurveysCount = await getCompletedSurveysCount();
        return completedSurveysCount >= condition.value!;
      case 'pointsThreshold':
        return (authRepository.userData?.points ?? 0) >= condition.value!;
      default:
        return false;
    }
  }

  Future<int> getCompletedSurveysCount() {
    return responsesCollection
        .where('userId', isEqualTo: authRepository.uid)
        .get()
        .then((value) => value.size);
  }

  Future<List<EarnedBadge>> fetchEarnedBadgesForUser(String userId) async {
    try {
      DocumentSnapshot userDoc = await usersCollection.doc(userId).get();
      List<dynamic> earnedBadgesData =
          (userDoc.data() as Map<String, dynamic>?)?['earnedBadges'] ?? [];

      return earnedBadgesData.map<EarnedBadge>((badgeData) {
        return EarnedBadge.fromMap(badgeData as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching earned badges for user $userId: $e');
      return [];
    }
  }

  Future<void> awardBadgeManually(String userId, String badgeId) async {
    EarnedBadge newEarnedBadge = EarnedBadge(
      badgeId: badgeId,
      earnedAt: DateTime.now(),
    );

    await usersCollection.doc(userId).update({
      'earnedBadges': FieldValue.arrayUnion([newEarnedBadge.toMap()]),
    });

    notifyListeners();
  }

  Future<void> _awardBadge(String badgeId) async {
    try {
      DocumentSnapshot userDoc =
      await usersCollection.doc(authRepository.uid).get();

      List<dynamic> earnedBadges =
          (userDoc.data() as Map<String, dynamic>?)?['earnedBadges'] ?? [];

      bool badgeExists =
      earnedBadges.any((badge) => badge['badgeId'] == badgeId);

      if (!badgeExists) {
        EarnedBadge newEarnedBadge = EarnedBadge(
          badgeId: badgeId,
          earnedAt: DateTime.now(),
        );

        await usersCollection.doc(authRepository.uid).update({
          'earnedBadges': FieldValue.arrayUnion([newEarnedBadge.toMap()]),
        });

        notifyListeners();
      }
    } catch (e) {
      print('Error awarding badge: $e');
    }
  }
}
