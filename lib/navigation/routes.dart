class AppRoutes {
  /// All users routes ///
  static const String signinRoute = '/signin';
  static const String signupRoute = '/signup';
  static const String resetPasswordRoute = '/reset-password';
  static const String welcomeRoute = '/welcome';
  static const String homeRoute = '/home';  
  static const String profileRoute = '/profile';
  static const String editProfileRoute = '/edit-profile';
  static const String leaderboardRoute = '/leaderboard';
  static const String settingsRoute = '/settings';
  static const String aboutRoute = '/about';
  static const String onboardingRoute = '/onboarding';

  /// Regular user routes ///
  static const String userPendingApprovalRoute = '/user-pending-approval';

  /// Club member routes ///
  static const String clubMemberReportsRoute = '/club-member-reports';
  static const String badgesRoute = '/badges-details';
  static const String rewardsRoute = '/rewards';
  static const String pointsDetailsRoute = '/points-details';
  static const String fillSurveyRoute = '/fill-survey';

  /// Admin routes ///
  static const String adminManageReportsRoute = '/admin-manage-reports';
  static const String adminManageUsersRoute = '/admin-manage-users';
  static const String adminManageUserRoute = '/admin-manage-user';
  static const String configurationRoute = '/configuration';
  static const String notifyUsersRoute = '/notify-users';
  static const String manageSurveyRoute = '/manage-surveys';
}
