// Validators for name, display name, email and password fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:yalla_negev/models/users/user_data.dart';
import 'package:yalla_negev/utils/globals.dart';
import '../../../../generated/l10n.dart';

String? nameValidatorAllowsEmpty(String? value,BuildContext context) {
  var l10n = S.of(context);
  if (value == null || value.trim().isEmpty) {
    return null;
  } else if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value)) {
    return l10n.enterAlphabetic;
  } else if (value.trim().length < 2) {
    return l10n.nameLength;
  }
  return null;
}

String? nameValidator(String? value,BuildContext context) {
  var l10n = S.of(context);
  if (value == null || value.trim().isEmpty) {
    return l10n.enterName;
  } else if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value)) {
    return l10n.enterAlphabetic;
  } else if (value.trim().length < 2) {
    return l10n.nameLength;
  }
  return null;
}

String? displayNameValidatorAllowsEmpty(String? value,BuildContext context) {
  var l10n = S.of(context);
  if (value == null || value.trim().isEmpty) {
    return null;
  } else if (!RegExp(r'^[a-zA-Z0-9]*$').hasMatch(value)) {
    return l10n.enterAlphanumeric;
  } else if (value.trim().length < 2) {
    return l10n.displayNameLength;
  }
  return null;
}

String? displayNameValidator(String? value, BuildContext context, {bool checkEmptyName = true}) {
  var l10n = S.of(context);
  if (!checkEmptyName) return null;
  if (value == null || value.trim().isEmpty) {
    return l10n.enterDisplayName;
  } else if (!RegExp(r'^[a-zA-Z0-9]*$').hasMatch(value)) {
    return l10n.enterAlphanumeric;
  } else if (value.trim().length < 2) {
    return l10n.displayNameLength;
  }
  return null;
}

String? emailValidator(String? value,BuildContext context) {
  var l10n = S.of(context);
  if (value == null || value.isEmpty) {
    return l10n.enterEmail;
  } else if (!value.contains('@')) {
    return l10n.emailAt;
  } else if (!value.contains('.')) {
    return l10n.emailDot;
  } else if (value.contains(' ')) {
    return l10n.emailSpace;
  } else {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return l10n.validEmail;
    }
  }
  return null;
}

String? passwordValidator(String? value,BuildContext context) {
  var l10n = S.of(context);
  if (value == null || value.trim().isEmpty) {
    return l10n.enterPassword;
  } else if (value.length < 6) {
    return l10n.passwordLength;
  }
  return null;
}

Future<bool> checkIfDisplayNameExists(String displayName) async {
  // Get all documents in the users collection
  final QuerySnapshot<Map<String, dynamic>> snapshot =
      await usersCollection.get();

  // Iterate over each document in the snapshot
  for (var document in snapshot.docs) {
    // Get the user data from the document
    UserData user = UserData.fromFirebaseObject(document.data(), document.id);

    // Check if the display name already exists
    if (user.displayName == displayName) {
      return true;
    }
  }

  // If no matching display name is found, return false
  return false;
}
