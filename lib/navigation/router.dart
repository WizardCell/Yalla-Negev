import 'package:flutter/material.dart';
import 'package:yalla_negev/ui/screens/admin/surveys_manager/manage_surveys_screen.dart';
import 'package:yalla_negev/ui/screens/admin/users/manage_user_screen.dart';
import 'package:yalla_negev/ui/screens/all_users/authentication/reset_password_screen.dart';
import 'package:yalla_negev/ui/screens/all_users/authentication/welcome_screen.dart';
import 'package:yalla_negev/ui/screens/all_users/authentication/signin_screen.dart';
import 'package:yalla_negev/ui/screens/all_users/authentication/signup_screen.dart';
import 'package:yalla_negev/ui/screens/all_users/default_route_widget.dart';
import 'package:yalla_negev/ui/screens/all_users/profile/edit_profile_screen.dart';
import 'package:yalla_negev/ui/screens/all_users/profile/profile_screen.dart';
import 'package:yalla_negev/ui/screens/all_users/general/settings_screen.dart';
import 'package:yalla_negev/ui/screens/all_users/general/about_screen.dart';
import 'package:yalla_negev/ui/screens/club_member/gamification/leaderboard_screen.dart';
import 'package:yalla_negev/ui/screens/club_member/reports/reports_screen.dart';
import 'package:yalla_negev/ui/screens/regular_user/pending_approval_screen.dart';
import 'package:yalla_negev/navigation/routes.dart';

import '../models/surveys/survey.dart';
import '../ui/screens/admin/admin_configuration.dart';
import '../ui/screens/admin/admin_home.dart';
import '../ui/screens/admin/notification/notify_users_screen.dart';
import '../ui/screens/admin/surveys_manager/manage_survey_screen.dart';
import '../ui/screens/club_member/gamification/badges_screen.dart';
import '../ui/screens/club_member/gamification/points_details_screen.dart';
import '../ui/screens/club_member/gamification/rewards_screen.dart';
import '../ui/screens/club_member/reports/fill_survey_screen.dart';
import '../ui/widgets/app_bottom_navigation_bar.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  // TODO: Mossa, Check how to dismiss keyboard when navigating so you don't see screen stutters
  switch (settings.name) {
    case AppRoutes.signinRoute:
      return MaterialPageRoute(builder: (context) => const SignInScreen());
    case AppRoutes.signupRoute:
      return MaterialPageRoute(builder: (context) => const SignupScreen());
    case AppRoutes.resetPasswordRoute:
      return MaterialPageRoute(
          builder: (context) => const ResetPasswordScreen());
    case AppRoutes.welcomeRoute:
      return MaterialPageRoute(builder: (context) => const WelcomeScreen());
    case AppRoutes.leaderboardRoute:
      return MaterialPageRoute(builder: (context) => const LeaderboardScreen());
    case AppRoutes.rewardsRoute:
      return MaterialPageRoute(builder: (context) => const RewardsScreen());
    case AppRoutes.badgesRoute:
      return MaterialPageRoute(builder: (context) => const BadgesScreen());
    case AppRoutes.pointsDetailsRoute:
      return MaterialPageRoute(builder: (context) => const PointsDetailsScreen());
    case AppRoutes.profileRoute:
      return MaterialPageRoute(
          builder: (context) => ProfileScreen(tab: BottomBarEnum.profile));
    case AppRoutes.editProfileRoute:
      return MaterialPageRoute(builder: (context) => const EditProfileScreen());
    case AppRoutes.settingsRoute:
      return MaterialPageRoute(builder: (context) => const SettingsScreen());
  // case profileRoute:
  //   if (settings.arguments != null) {
  //     final args = settings.arguments as SearchArguments;
  //     return MaterialPageRoute(builder: (context) => ProfileScreen(uid: args.uid));
  //   }
  //   return MaterialPageRoute(builder: (context) => ProfileScreen());
    case AppRoutes.aboutRoute:
      return MaterialPageRoute(builder: (context) => const AboutScreen());
    case AppRoutes.userPendingApprovalRoute:
      return MaterialPageRoute(
          builder: (context) => const PendingApprovalScreen());

    case AppRoutes.fillSurveyRoute:
      final surveyArg = settings.arguments as Survey;

      return MaterialPageRoute(builder: (context) => FillSurveyScreen(survey: surveyArg));
    case AppRoutes.clubMemberReportsRoute:
      return MaterialPageRoute(builder: (context) => const ViewReportsScreen());
    case AppRoutes.configurationRoute:
      return MaterialPageRoute(
          builder: (context) => const AdminConfigurationScreen());

    case AppRoutes.adminManageReportsRoute:
      return MaterialPageRoute(
          builder: (context) => const ManageSurveysScreen());
    /*case AppRoutes.manageSurveyRoute:
      final survey = settings.arguments as Survey;
      return MaterialPageRoute(
          builder: (context) => ManageSurveyScreen(survey: survey));*/

    case AppRoutes.adminManageUsersRoute:
      final userId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => ManageUserScreen(userId: userId));

    case AppRoutes.notifyUsersRoute:
      return MaterialPageRoute(builder: (context) => const NotifyUsersScreen());

    default:
      return MaterialPageRoute(builder: (context) => const DefaultRouteWidget());
  }
}
