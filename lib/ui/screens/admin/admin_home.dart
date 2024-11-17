import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/providers/responses_provider.dart';
import 'package:yalla_negev/providers/users_manager_provider.dart';
import 'package:yalla_negev/ui/screens/admin/admin_dashboard.dart';

import '../../../providers/navigation_provider.dart';
import '../../../providers/user_provider.dart';
import '../../widgets/app_bottom_navigation_bar.dart';
import '../all_users/profile/profile_screen.dart';
import 'admin_configuration.dart';
import 'surveys_manager/manage_surveys_screen.dart';
import 'users/manage_users_screen.dart';

class AdminHome extends StatelessWidget {
  AdminHome({this.tab = BottomBarEnum.surveys, super.key}) {
    _profileScreen = ProfileScreen();
    _screens = {
      BottomBarEnum.surveys: const AdminDashboard(),
      BottomBarEnum.users: ManageUsersScreen(),
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
        ChangeNotifierProvider<UsersManagerProvider>(
          create: (_) => UsersManagerProvider(),
        ),
      ],
      child: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, child) {
          if (navigationProvider.currentTab != BottomBarEnum.profile &&
              _profileScreen.isMenuOpen) {
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
