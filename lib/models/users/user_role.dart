import 'package:flutter/material.dart';
import 'package:yalla_negev/generated/l10n.dart';

enum UserRole { none, user, clubMember, admin }

extension UserRoleExtension on UserRole {
  String toLocalizedString(BuildContext context) {
    var l10n = S.of(context);
    switch (this) {
      case UserRole.none:
        return l10n.userRoleNone;
      case UserRole.user:
        return l10n.userRoleUser;
      case UserRole.clubMember:
        return l10n.userRoleClubMember;
      case UserRole.admin:
        return l10n.userRoleAdmin;
      default:
        return '';
    }
  }
}
