import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/ui/screens/all_users/profile/user_title_widget.dart';

import '../../../../generated/l10n.dart';
import '../../../../models/gamification/yalla_badge.dart';
import '../../../../models/users/user_data.dart';
import '../../../../providers/bonus_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../../../providers/users_manager_provider.dart';
import '../../../theme/button_styles.dart';

class ManageUserScreen extends StatelessWidget {
  const ManageUserScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<UsersManagerProvider>(context).users;

    final user = users.firstWhere((element) => element.id == userId);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<UsersManagerProvider>(
          builder: (context, usersManagerProvider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserTitleWidget(user: user),
                const SizedBox(height: 8),
                _buildJoinDate(context, user),
                const SizedBox(height: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _buildActionButtons(context, user),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildJoinDate(BuildContext context, UserData user) {
    final l10n = S.of(context);
    final joinDate = user.joinDate;
    final formattedJoinDate = DateFormat.yMMMd().format(joinDate!);

    return Text(
      l10n.joinDate(formattedJoinDate),
      style: Theme.of(context).textTheme.titleSmall,
      textAlign: TextAlign.start,
    );
  }

  List<Widget> _buildActionButtons(BuildContext context, UserData user) {
    List<Widget> widgets = [];

    final l10n = S.of(context);
    final usersManagerProvider =
        Provider.of<UsersManagerProvider>(context, listen: false);

    if (user.role == UserRole.user) {
      widgets.addAll([
        SizedBox(
          width: ButtonStyles.buttonWidthWider,
          child: ElevatedButton(
            onPressed: () {
              usersManagerProvider.changeRole(user.id, UserRole.clubMember);
            },
            style: ButtonStyles.primaryButtonStyle,
            child: Text(l10n.upgradeUser(user.displayName)),
          ),
        ),
        const SizedBox(height: 12),
        Text(l10n.upgradeUserNotice, textAlign: TextAlign.center)
      ]);
    } else if (user.role == UserRole.clubMember) {
      widgets.addAll([
        SizedBox(
          width: ButtonStyles.buttonWidthWider,
          child: ElevatedButton(
            onPressed: () {
              usersManagerProvider.changeRole(user.id, UserRole.user);
            },
            style: ButtonStyles.secondaryButtonStyle,
            child: Text(l10n.downgradeUser(user.displayName)),
          ),
        ),
        const SizedBox(height: 12),
        Text(l10n.downgradeUserNotice, textAlign: TextAlign.center)
      ]);
    }

    if (user.role != UserRole.admin) {
      widgets.addAll([
        const SizedBox(height: 12),
        SizedBox(
          width: ButtonStyles.buttonWidthWider,
          child: ElevatedButton(
            onPressed: () => _showPromoteToAdminDialog(context, user),
            style: ButtonStyles.secondaryButtonStyle,
            child: Text(l10n.promoteToAdmin(user.displayName)),
          ),
        ),
        const SizedBox(height: 12),
        Text(l10n.promoteToAdminNotice, textAlign: TextAlign.center)
      ]);
    } else {
      widgets.addAll([
        const SizedBox(height: 12),
        SizedBox(
          width: ButtonStyles.buttonWidthWider,
          child: ElevatedButton(
            onPressed: () {
              usersManagerProvider.changeRole(user.id, UserRole.clubMember);

              final userProvider =
                  Provider.of<AuthRepository>(context, listen: false);
              if (userProvider.userData!.id == user.id) {
                userProvider.signOut(context);
              }
            },
            style: ButtonStyles.secondaryButtonStyle,
            child: Text(l10n.revokeAdmin(user.displayName)),
          ),
        ),
        const SizedBox(height: 12),
        Text(l10n.revokeAdminNotice, textAlign: TextAlign.center)
      ]);
    }

    widgets.addAll([
      const SizedBox(height: 12),
      SizedBox(
        width: ButtonStyles.buttonWidthWider,
        child: ElevatedButton(
          onPressed: () => _showManualAwardBadgeDialog(context, user),
          style: ButtonStyles.primaryButtonStyle,
          child: Text(l10n.manualAwardBadge),
        ),
      ),
      const SizedBox(height: 12),
    ]);

    return widgets;
  }

  void _showPromoteToAdminDialog(BuildContext context, UserData user) {
    final l10n = S.of(context);
    final usersManagerProvider =
        Provider.of<UsersManagerProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.promoteToAdmin(user.displayName)),
          content: Text(l10n.promoteToAdminConfirmation(user.displayName)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                usersManagerProvider.changeRole(user.id, UserRole.admin);
                Navigator.of(context).pop();
              },
              child: Text(l10n.confirm),
            ),
          ],
        );
      },
    );
  }

  void _showManualAwardBadgeDialog(BuildContext context, UserData user) async {
    final l10n = S.of(context);
    final usersManagerProvider =
    Provider.of<UsersManagerProvider>(context, listen: false);
    final badgesProvider =
    Provider.of<BonusProvider>(context, listen: false);

    List<YallaBadge> allBadges = await badgesProvider
        .fetchAvailableBadges(conditionType: 'manual');
    List<EarnedBadge> earnedBadges = await badgesProvider
        .fetchEarnedBadgesForUser(user.id);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedBadgeId;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.manualAwardBadgeTitle),
              content: DropdownButton<String>(
                isExpanded: true,
                hint: Text(l10n.selectBadge),
                value: selectedBadgeId,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBadgeId = newValue;
                  });
                },
                items: allBadges.map((badge) {
                  bool isBadgeAlreadyEarned = earnedBadges
                      .any((earnedBadge) => earnedBadge.badgeId == badge.id);

                  return DropdownMenuItem<String>(
                    value: badge.id,
                    enabled: !isBadgeAlreadyEarned,
                    child: Text(
                      badge.name.getLocalizedText(context),
                      style: TextStyle(
                        color: isBadgeAlreadyEarned
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedBadgeId != null) {
                      badgesProvider.awardBadgeManually(
                        user.id,
                        selectedBadgeId!,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(l10n.awardBadge),
                ),
              ],
            );
          },
        );
      },
    );
  }

}
