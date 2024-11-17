import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/providers/responses_provider.dart';
import 'package:yalla_negev/ui/screens/club_member/gamification/leaderboard_screen.dart';
import 'package:yalla_negev/ui/screens/regular_user/pending_approval_screen.dart';

import '../../../providers/navigation_provider.dart';
import '../../../providers/user_provider.dart';
import '../../widgets/app_bottom_navigation_bar.dart';
import '../all_users/profile/profile_screen.dart';

class RegularUserHome extends StatelessWidget {
  RegularUserHome({this.tab = BottomBarEnum.surveys, super.key}) {
    _profileScreen = ProfileScreen();
    _screens = {
      BottomBarEnum.surveys: const PendingApprovalScreen(),
      BottomBarEnum.users: const LeaderboardScreen(),
      BottomBarEnum.profile: _profileScreen,
    };
  }

  final BottomBarEnum tab;
  late final ProfileScreen _profileScreen;
  late final Map<BottomBarEnum, Widget> _screens;

  final Map<BottomBarEnum, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomBarEnum.surveys: GlobalKey<NavigatorState>(),
    BottomBarEnum.users: GlobalKey<NavigatorState>(),
    BottomBarEnum.profile: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ResponsesProvider>(
          create: (_) => ResponsesProvider(authRepository: Provider.of<AuthRepository>(context, listen: false)),
        ),
      ],
      child: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, child) {
          if (navigationProvider.currentTab != BottomBarEnum.profile &&
              _profileScreen.isMenuOpen) {
            // This ensures that the popup menu in profile screen is closed when the user navigates to a different tab
            _profileScreen.isMenuOpen = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(_profileScreen.menuKey.currentContext!);
            });
          }
          return Scaffold(
            body: Stack(
              children: BottomBarEnum.values.map((tab) {
                return Offstage(
                  offstage: navigationProvider.currentTab != tab,
                  child: Navigator(
                    key: navigatorKeys[tab],
                    onGenerateRoute: (routeSettings) {
                      return MaterialPageRoute(
                        builder: (context) => _screens[tab]!,
                      );
                    },
                  ),
                );
              }).toList(),
            ),
            bottomNavigationBar: const AppBottomNavigationBar(),
          );
        },
      ),
    );
  }
}
