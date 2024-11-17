import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:yalla_negev/generated/l10n.dart';
import 'package:yalla_negev/ui/theme/app_colors.dart';

import '../../../navigation/navigation_service.dart';
import '../../../navigation/routes.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.adminDashboard,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: <Widget>[
            _buildDashboardTile(
              context,
              icon: MdiIcons.fileDocumentOutline,
              label: l10n.surveys,
              onTap: () {
                NavigatorService.pushNamed(AppRoutes.adminManageReportsRoute);
              },
            ),
            _buildDashboardTile(
              context,
              icon: MdiIcons.cogOutline,
              label: l10n.configuration,
              onTap: () {
                NavigatorService.pushNamed(AppRoutes.configurationRoute);
              },
            ),
            // _buildDashboardTile(
            //   context,
            //   icon: MdiIcons.badgeAccountOutline,
            //   label: l10n.badges,
            //   onTap: () => _showBadgesNotSupportedDialog(context),
            // ),
            _buildDashboardTile(
              context,
              icon: MdiIcons.broadcast,
              label: l10n.notifyUsers,
              onTap: () =>
                  {NavigatorService.pushNamed(AppRoutes.notifyUsersRoute)},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 50.0, color: AppColors.primaryColor),
            const SizedBox(height: 16.0),
            Text(
              label,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgesNotSupportedDialog(BuildContext context) {
    var l10n = S.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.badgesEditingTitle),
          content: Text(l10n.badgesEditingMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }
}
