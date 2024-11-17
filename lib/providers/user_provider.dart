import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/models/users/user_data.dart';
import 'package:yalla_negev/providers/language_provider.dart';
import 'package:yalla_negev/providers/navigation_provider.dart';
import 'package:yalla_negev/utils/globals.dart';
import 'package:yalla_negev/utils/locale_helper.dart';
import 'package:yalla_negev/utils/validators.dart';

import '../models/gamification/earned_badge.dart';
import '../models/gamification/points_transaction.dart';
import '../models/surveys/localized_text.dart';

enum Status { unauthenticated, authenticating, authenticated }

enum SignUpErrors {
  mailAlreadyExists,
  weakPassword,
  invalidEmail,
  mailAlreadyExistsWithDifferentCredential,
  displayNameAlreadyExists,
}

class AuthRepository extends ChangeNotifier {
  User? _user;
  UserData? _userData;
  Status _status = Status.unauthenticated;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  int _ranking = 0; // Not stored in Firebase, but maintained locally

  static String bonusText = "שלום | مرحبا | hello";
  static const String welcomeBadgeId = 'qXdS6yM8sLjegrwHeO9i';

  /// Getters
  Status get status => _status;

  User? get user => _user;

  bool get isAuthenticated => status == Status.authenticated;

  UserData? get userData => _userData;

  String get uid => user!.uid;

  int get ranking => _ranking;

  AuthRepository.instance() {
    firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
    _user = firebaseAuth.currentUser;
    _onAuthStateChanged(_user);
  }

  void _onAuthStateChanged(User? user) async {
    if (user == null) {
      _user = null;
      _status = Status.unauthenticated;
    } else {
      _user = user;
      _status = Status.authenticated;
      await populateUserData();
    }
    notifyListeners();
  }

  Stream<UserData> streamUserData() {
    return usersCollection.doc(user?.uid).snapshots().map((snapshot) {
      return UserData.fromFirebaseObject(snapshot.data(), snapshot.id);
    });
  }

  Future<void> populateUserData() async {
    try {
      if (!isAuthenticated || user == null) return;
      DocumentSnapshot userDataDoc = await usersCollection.doc(user!.uid).get();
      _userData = UserData.fromFirebaseObject(
          userDataDoc.data() as Map<String, dynamic>?, user!.uid);
    } catch (e) {
      print('error populating user data: $e');
      await Future.delayed(const Duration(seconds: 1));

      if (!isAuthenticated || user == null) return;

      DocumentSnapshot userDataDoc = await usersCollection.doc(user!.uid).get();
      _userData = UserData.fromFirebaseObject(
          userDataDoc.data() as Map<String, dynamic>?, user!.uid);
    }
  }

  Future<void> unpopulateUserData() async {
    _user = null;
    _userData = null;
    _status = Status.unauthenticated;
    notifyListeners();
  }

  Future<void> updateUserData({
    String? newName,
    String? newDisplayName,
    int? newPoints,
    File? newPic,
    UserRole? newRole,
    bool? newPrefersDarkTheme,
    String? newLanguage,
    bool? welcomeRewardGiven,
  }) async {
    try {
      if (newName != null) _userData!.name = newName;
      if (newDisplayName != null) _userData!.displayName = newDisplayName;
      if (newPoints != null) _userData!.points = newPoints;
      if (newPic != null && newPic.path != _userData!.pictureUrl) {
        var ref = storage.ref().child('images').child(user!.uid);
        await ref.putFile(newPic);
        _userData!.pictureUrl = await ref.getDownloadURL();
      }
      if (newRole != null) _userData!.role = newRole;

      if (newPrefersDarkTheme != null) {
        _userData!.prefersDarkTheme = newPrefersDarkTheme;
      }

      if (newLanguage != null) {
        _userData!.language = newLanguage;
      }

      if (welcomeRewardGiven != null) {
        _userData!.welcomeRewardGiven = welcomeRewardGiven;
      }

      await usersCollection
          .doc(user!.uid)
          .update(_userData!.toFirebaseObject());

      notifyListeners();
    } catch (e) {
      print('Failed to update user data: $e');
    }
  }

  void setRanking(int ranking) {
    this._ranking = ranking;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.authenticating;
      notifyListeners();
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      print('Failed to sign in: $e');
      unpopulateUserData();
      return false;
    }
  }

  Future<Object?> signUp(
      String email, String password, String name, String displayName) async {
    UserCredential? userCredential;
    try {
      _status = Status.authenticating;
      notifyListeners();

      // Check if display name already exists
      bool displayNameExists = await checkIfDisplayNameExists(displayName);

      if (displayNameExists) {
        // Display name already exists, return an error
        return SignUpErrors.displayNameAlreadyExists;
      }

      userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      var url = await storage
          .ref('images')
          .child('ProfilePicture.png')
          .getDownloadURL();

      final description = LocalizedText(
        en: bonusText,
        ar: bonusText,
        he: bonusText,
      );

      UserData? userData = UserData(
        id: userCredential.user!.uid,
        name: name,
        displayName: displayName,
        email: email,
        points: 5,
        pictureUrl: url,
        role: UserRole.user,
        joinDate: DateTime.now(),
        language: getLanguageFromSupportedLocale(defaultLocale),
        earnedBadges: [
          EarnedBadge(
            badgeId: welcomeBadgeId,
            earnedAt: DateTime.now(),
          ),
        ],
      );

      // Save the user data in the repository locally so we have it ready to use quiet fast
      _userData = userData;

      await usersCollection.doc(user!.uid).set(userData.toFirebaseObject());
      await pointsTransactionsCollection.add(
        PointsTransaction.newTransaction(
          user!.uid,
          5,
          description,
        ).toMap(),
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      unpopulateUserData();
      if (userCredential != null) {
        await userCredential.user!.delete();
      }
      switch (e.code) {
        case 'email-already-in-use':
          return SignUpErrors.mailAlreadyExists;
        case 'weak-password':
          return SignUpErrors.weakPassword;
        case 'invalid-email':
          return SignUpErrors.invalidEmail;
        default:
          return e.code;
      }
    } catch (e) {
      print('Failed to sign up: $e');
      unpopulateUserData();
      if (userCredential != null) {
        await userCredential.user!.delete();
      }
      return e;
    }
  }

  Future<Object?> signInWithGoogle() async {
    try {
      final googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleSignInAccount?.authentication;

      if (googleAuth == null) {
        unpopulateUserData();
        return 0;
      }

      final cred = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      var res = await firebaseAuth.signInWithCredential(cred);

      if (res.additionalUserInfo!.isNewUser) {
        final name = res.user?.displayName;
        final picture = res.user?.photoURL;

        String googleDisplayName = res.user!.email!.split('@').first;

        // Check if display name already exists
        bool displayNameExists =
            await checkIfDisplayNameExists(googleDisplayName);
        while (displayNameExists) {
          // Generate a random number between 7 and 10
          int randomEnd = Random().nextInt(4) + 7;
          // We take the first 7 to 10 characters of the google email, append to it the hypen sumbol and then append the last 6 characters
          // of the current time in milliseconds. A timestamp in milliseconds is typically 13 characters long. It will become 14 in the year 2286.
          googleDisplayName =
              '${googleDisplayName.substring(0, randomEnd)}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
          displayNameExists = await checkIfDisplayNameExists(googleDisplayName);
        }

        UserData? userData = UserData(
          id: res.user!.uid,
          name: name!,
          displayName: googleDisplayName,
          email: res.user!.email!,
          points: 0,
          pictureUrl: picture,
          role: UserRole.user,
          joinDate: DateTime.now(),
          language: getLanguageFromSupportedLocale(defaultLocale),
        );

        // Save the user data in the repository locally so we have it ready to use quiet fast
        _userData = userData;

        await usersCollection
            .doc(res.user!.uid)
            .set(userData.toFirebaseObject());
      }

      return cred;
    } on FirebaseAuthException catch (e) {
      print('Failed to sign in with Google: $e');
      unpopulateUserData();
      switch (e.code) {
        case 'account-exists-with-different-credential':
          return SignUpErrors.mailAlreadyExistsWithDifferentCredential;
        default:
          return e.code;
      }
    } catch (e) {
      print('Failed to sign in with Google: $e');
      unpopulateUserData();
      return e;
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      unpopulateUserData();
      // Reset the tab
      Provider.of<NavigationProvider>(context, listen: false).resetTab();

      if (googleSignIn.currentUser != null) {
        await googleSignIn.signOut();
      }
      await firebaseAuth.signOut();
    } catch (e) {
      // Handle error
      print('Failed to sign out: $e');
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (_) {
      return false;
    }
  }

  int getUserPoints() {
    return _userData?.points ?? 0;
  }

  Future<void> updateUserPoints(int points) async {
    if (_userData != null) {
      _userData!.points = points;
      await usersCollection
          .doc(_user!.uid)
          .update(_userData!.toFirebaseObject());
      notifyListeners();
    }
  }
}
