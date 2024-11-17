import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/models/users/user_data.dart';
import 'package:yalla_negev/providers/navigation_provider.dart';
import 'package:yalla_negev/providers/user_provider.dart';
import 'package:yalla_negev/navigation/navigation_service.dart';
import 'package:yalla_negev/ui/screens/all_users/profile/report_row.dart';
import 'package:yalla_negev/ui/screens/all_users/profile/user_title_widget.dart';
import 'package:yalla_negev/ui/widgets/app_bottom_navigation_bar.dart';
import 'package:yalla_negev/utils/globals.dart';
import 'package:yalla_negev/utils/locale_helper.dart';
import 'package:yalla_negev/navigation/routes.dart';

import '../../../../generated/l10n.dart';

enum ProfileMenuTabs { editProfile, settings, about, signOut }

class ProfileScreen extends StatefulWidget {
  ProfileScreen({this.tab = BottomBarEnum.profile, super.key});

  final BottomBarEnum tab;

  @override
  ProfileScreenState createState() => ProfileScreenState();

  bool get isMenuOpen {
    if (state != null) {
      return state!.isMenuOpen.value;
    }
    return false;
  }

  set isMenuOpen(bool value) {
    if (state != null) {
      state!.isMenuOpen.value = value;
    }
  }

  GlobalKey get menuKey {
    if (state != null) {
      return state!.menuKey;
    }
    return GlobalKey();
  }

  ProfileScreenState? get state => _state;
  ProfileScreenState? _state;
}

class ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey menuKey = GlobalKey();
  final ValueNotifier<bool> isMenuOpen = ValueNotifier<bool>(false);
  UserRole _previousRole = UserRole.none;

  @override
  void initState() {
    super.initState();
    widget._state = this;
  }

  @override
  void dispose() {
    widget._state = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);
    final authRepo = Provider.of<AuthRepository>(context, listen: true);

    return FutureBuilder(
      future: authRepo.populateUserData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading spinner while waiting
        } else if (snapshot.hasError) {
          return Text(
              '${l10n.error}: ${snapshot.error}'); // Show an error message if something went wrong
        } else {
          _previousRole = authRepo.userData!.role;
          return Stack(
            children: [
              buildScaffold(context, l10n, authRepo),
              buildRoleChangeDialog(authRepo, context),
            ],
          );
        }
      },
    );
  }

  StreamBuilder<UserData> buildRoleChangeDialog(
      AuthRepository authRepo, BuildContext context) {
    var l10n = S.of(context);
    return StreamBuilder<UserData>(
      stream: authRepo.streamUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasData && _previousRole != UserRole.none) {
          UserData newUserData = snapshot.data!;
          UserRole role = newUserData.role;

          // If the role has changed, show a dialog
          if (role != _previousRole && _previousRole != UserRole.none) {
            authRepo.userData!.role = role;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      role.index < _previousRole.index
                          ? l10n.sorry
                          : l10n.congratulations,
                    ),
                    content: Text(
                      role.index < _previousRole.index
                          ? '${l10n.youHaveBeenDemotedTo}'
                              ' ${getLocalizedUserRole(context, newUserData.role)}.'
                          : '${l10n.youHaveBeenPromotedTo}'
                              ' ${getLocalizedUserRole(context, newUserData.role)}!',
                    ),
                    actions: [
                      TextButton(
                        child: Text(l10n.ok),
                        onPressed: () {
                          // Close the dialog alongside all other screens and navigate to the home screen
                          NavigatorService.pushNamedAndRemoveUntil(
                              AppRoutes.homeRoute);
                          Provider.of<NavigationProvider>(context,
                                  listen: false)
                              .resetTab();
                          _previousRole = role;
                        },
                      ),
                    ],
                  );
                },
              );
            });
          }
        }
        return Container(); // Return an empty container when there's no data
      },
    );
  }

  Scaffold buildScaffold(
      BuildContext context, S l10n, AuthRepository authRepo) {
    return Scaffold(
      appBar: buildAppBar(l10n, authRepo, context),
      body: buildBody(l10n, authRepo),
    );
  }

  AppBar buildAppBar(S l10n, AuthRepository authRepo, BuildContext context) {
    return AppBar(
      title: Text(
        l10n.profile,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        buildPopupMenuButton(l10n, authRepo, context),
      ],
    );
  }

  PopupMenuButton<String> buildPopupMenuButton(
      S l10n, AuthRepository authRepo, BuildContext context) {
    return PopupMenuButton<String>(
      key: menuKey,
      offset: const Offset(0,
          kToolbarHeight), // This ensures the menu appear beneath the app bar
      onOpened: () {
        isMenuOpen.value = true;
      },
      onSelected: (String result) async {
        isMenuOpen.value = false;
        if (result == ProfileMenuTabs.signOut.toString()) {
          await authRepo.signOut(context);
          NavigatorService.pushNamedAndRemoveUntil(AppRoutes.welcomeRoute);
        } else if (result == ProfileMenuTabs.editProfile.toString()) {
          NavigatorService.pushNamed(AppRoutes.editProfileRoute);
        } else if (result == ProfileMenuTabs.settings.toString()) {
          NavigatorService.pushNamed(AppRoutes.settingsRoute);
        } else if (result == ProfileMenuTabs.about.toString()) {
          NavigatorService.pushNamed(AppRoutes.aboutRoute);
        }
      },
      onCanceled: () {
        isMenuOpen.value = false;
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        buildPopupMenuItem(
            ProfileMenuTabs.editProfile, Icons.edit, l10n.editProfile),
        buildPopupMenuItem(
            ProfileMenuTabs.settings, Icons.settings, l10n.settings),
        buildPopupMenuItem(ProfileMenuTabs.about, Icons.info, l10n.about),
        buildPopupMenuItem(ProfileMenuTabs.signOut, Icons.logout, l10n.signOut),
      ],
    );
  }

  PopupMenuItem<String> buildPopupMenuItem(
      ProfileMenuTabs tab, IconData icon, String text) {
    return PopupMenuItem<String>(
      value: tab.toString(),
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
      ),
    );
  }

  Widget buildBody(S l10n, AuthRepository authRepo) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(16, 16, 16, 0), // left, top, right, bottom
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UserTitleWidget(user: authRepo.userData!),
          const SizedBox(height: 16),
          const Divider(color: Colors.grey),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Colors.grey, width: 1.0), // This adds a underline
              ),
            ),
            child: Text(
              l10n.myReports,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: buildListView()),
        ],
      ),
    );
  }

  Widget buildListView() {
    var l10n = S.of(context);
    return StreamBuilder<QuerySnapshot>(
      stream: responsesCollection
          .where('userId', isEqualTo: getCurrUid())
          .orderBy('submittedTs', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(l10n.somethingWentWrong);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(l10n.noReportsSubmittedYet),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ReportRow(
                      document: snapshot.data!.docs[index],
                      index: snapshot.data!.docs.length -
                          index - 1), // Subtract index from total length
                  if (index != snapshot.data!.docs.length - 1)
                    const SizedBox(height: 10),
                ],
              );
            },
          );
        }
      },
    );
  }
}
