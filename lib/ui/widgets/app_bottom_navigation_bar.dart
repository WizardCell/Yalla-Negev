import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/models/users/user_data.dart';
import 'package:yalla_negev/providers/user_provider.dart';
import '../../generated/l10n.dart';
import '../../providers/navigation_provider.dart';
import '../../navigation/routes.dart';

enum BottomBarEnum { surveys, users, profile }

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  Icon getUsersTabIconBasedOnRole(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return const Icon(Icons.people);
      case UserRole.clubMember:
        return const Icon(Icons.star);
      default:
        return const Icon(Icons.leaderboard);
    }
  }

  String getUsersLabelBasedOnRole(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return S.current.users;
      case UserRole.clubMember:
        return S.current.rewards;
      default:
        return S.current.leaderboard;
    }
  }

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);
    final navigationProvider = Provider.of<NavigationProvider>(context);
    // Get the role of the current user
    final userRole =
        Provider.of<AuthRepository>(context, listen: true).userData?.role;

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.search),
          label: (userRole ?? UserRole.user) == UserRole.admin ?
          l10n.configuration : l10n.surveys,
        ),
        BottomNavigationBarItem(
          icon: getUsersTabIconBasedOnRole(userRole),
          label: getUsersLabelBasedOnRole(userRole),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: l10n.profile,
        ),
      ],
      onTap: (index) {
        BottomBarEnum selectedTab;
        String route;

        switch (index) {
          case 0:
            selectedTab = BottomBarEnum.surveys;
            // Route the user based on their role
            if (userRole == UserRole.admin) {
              route = AppRoutes.adminManageReportsRoute;
            } else if (userRole == UserRole.clubMember) {
              route = AppRoutes.clubMemberReportsRoute;
            } else {
              route = AppRoutes.userPendingApprovalRoute;
            }
            break;
          case 1:
            selectedTab = BottomBarEnum.users;
            if (userRole == UserRole.admin) {
              route = AppRoutes.adminManageUsersRoute;
            } else {
              route = AppRoutes.rewardsRoute;
            }
            break;
          case 2:
            selectedTab = BottomBarEnum.profile;
            route = AppRoutes.profileRoute;
            break;
          default:
            return;
        }

        navigationProvider.selectTab(selectedTab);
        //NavigatorService.pushNamedAndRemoveUntil(route, arguments: {});
      },
      currentIndex: navigationProvider.currentTab.index,
    );
  }
}
