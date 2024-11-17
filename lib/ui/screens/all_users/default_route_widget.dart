import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/models/users/user_data.dart';
import 'package:yalla_negev/providers/user_provider.dart';
import 'package:yalla_negev/ui/screens/admin/admin_home.dart';
import 'package:yalla_negev/ui/screens/club_member/club_member_home.dart';
import 'package:yalla_negev/ui/screens/regular_user/regular_user_home.dart';
import 'package:yalla_negev/ui/screens/all_users/onboarding/onboarding_screen.dart';
import 'package:yalla_negev/ui/screens/all_users/authentication/welcome_screen.dart';
import 'package:yalla_negev/utils/preferences_utils.dart';

import 'general/loading_screen.dart';

class DefaultRouteWidget extends StatelessWidget {
  const DefaultRouteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: PreferencesUtils.getOnboardingShown(),
      builder: (context, snapshot) {
        if (snapshot.data == null
            || snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else {
          bool onboardingNeeded = snapshot.data ?? true;

          return Consumer<AuthRepository>(
            builder: (context, authRepo, child) {
              if(authRepo.status == Status.authenticating
              || (authRepo.status == Status.authenticated && authRepo.userData == null)
              ) {
                return const LoadingScreen();
              }

              var role = authRepo.userData?.role ?? UserRole.none;
              switch (role) {
                case UserRole.admin:
                  return AdminHome();
                case UserRole.clubMember:
                  return ClubMemberHome();
                case UserRole.user:
                  return RegularUserHome();
                default:
                  return onboardingNeeded
                      ? const OnboardingScreen()
                      : const WelcomeScreen();
              }
            },
          );
        }
      },
    );
  }
}
