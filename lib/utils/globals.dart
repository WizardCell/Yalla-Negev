import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore database = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;

const currentFirestoreVersion = "v1";

/// Collections
final CollectionReference<Map<String, dynamic>> usersCollection =
    database.collection("versions")
        .doc(currentFirestoreVersion).collection("users");
final CollectionReference<Map<String, dynamic>> surveysCollection =
    database.collection("versions")
        .doc(currentFirestoreVersion).collection("surveys");
final CollectionReference<Map<String, dynamic>> responsesCollection =
    database.collection("versions")
        .doc(currentFirestoreVersion).collection("responses");
final CollectionReference<Map<String, dynamic>> reportCategoriesCollection =
    database.collection("versions")
        .doc(currentFirestoreVersion).collection("reportCategories");
final CollectionReference<Map<String, dynamic>> pointsTransactionsCollection =
    database.collection("versions")
        .doc(currentFirestoreVersion).collection("pointsTransactions");
final CollectionReference<Map<String, dynamic>> badgesCollection =
    database.collection("versions").doc("v1").collection("badges");
final DocumentReference<Map<String, dynamic>> globalConfigDoc =
    database.collection("versions")
        .doc(currentFirestoreVersion).collection("config").doc("globalConfig");

/// Returns current user id
String? getCurrUid() {
  return firebaseAuth.currentUser?.uid;
}
