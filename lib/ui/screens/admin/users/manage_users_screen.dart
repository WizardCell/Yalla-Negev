import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/models/users/user_data.dart';
import 'package:yalla_negev/ui/screens/admin/users/manage_user_screen.dart';
import 'package:yalla_negev/ui/screens/admin/notification/notify_users_screen.dart';
import 'package:yalla_negev/ui/screens/club_member/gamification/leaderboard_screen.dart';

import '../../../../generated/l10n.dart';
import '../../../../providers/users_manager_provider.dart';

class ManageUsersScreen extends StatelessWidget {
  ManageUsersScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var l10n = S.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.manageUsers),
              Tab(text: l10n.leaderboard),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                _buildTopBar(context),
                Consumer<UsersManagerProvider>(
                  builder: (context, usersManagerProvider, child) {
                    if (usersManagerProvider.state ==
                        UsersManagerProviderState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (usersManagerProvider.state ==
                        UsersManagerProviderState.error) {
                      return Center(child: Text(S.of(context).error));
                    }

                    final users = usersManagerProvider.users;

                    return Expanded(
                      child: ListView.separated(
                        itemCount: users.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: theme.dividerColor,
                        ),
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return _buildUserTile(context, user);
                        },
                      ),
                    );
                  },
                )
              ],
            ),
            const LeaderboardScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    var l10n = S.of(context);
    final usersManagerProvider =
        Provider.of<UsersManagerProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.search,
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: (query) {
              usersManagerProvider.searchUsers(query);
            },
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  _showRoleFilterDialog(context);
                },
                icon: const Icon(Icons.filter_list),
                label: Text(l10n.filter),
              ),
              TextButton(
                onPressed: () {
                  _searchController.clear(); // Clear the search field
                  usersManagerProvider.clearFilters();
                },
                child: Text(l10n.resetFilters),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, UserData user) {
    var l10n = S.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.pictureUrl!),
      ),
      title: _buildUserTitle(user),
      trailing: Text('${user.points} ${l10n.points}'),
      onTap: () => {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ManageUserScreen(
            userId: user.id,
          ),
        )),
      },
    );
  }

  Widget? _buildUserTitle(UserData user) {
    Row userTileTitle = Row(children: [
      Expanded(
          child: Text(user.displayName,
              maxLines: 3, overflow: TextOverflow.ellipsis)),
    ]);

    final icon = _getIconForRole(user.role);
    if (icon != null) {
      userTileTitle.children.add(const SizedBox(width: 8));
      userTileTitle.children.add(icon);
    }

    return userTileTitle;
  }

  Widget? _getIconForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return const Icon(Icons.admin_panel_settings_outlined);
      case UserRole.clubMember:
        return const Icon(Icons.verified);
      case UserRole.user:
        return const Icon(Icons.person_outline);
      case UserRole.none:
      default:
        return const Icon(Icons.help_outline);
    }
  }

  void _showRoleFilterDialog(BuildContext context) {
    final usersManagerProvider =
        Provider.of<UsersManagerProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(S.of(context).filter),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: UserRole.values
                    .where((role) => role != UserRole.none)
                    .map((role) {
                  final isSelected = usersManagerProvider.isRoleSelected(role);
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        usersManagerProvider.toggleRoleSelection(role);
                      });
                    },
                    title: Row(
                      children: [
                        _getIconForRole(role) ?? Container(),
                        const SizedBox(width: 8),
                        Text(role.toLocalizedString(context)),
                      ],
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(S.of(context).cancel),
                ),
                TextButton(
                  onPressed: () {
                    usersManagerProvider.applyRoleFilter();
                    Navigator.of(context).pop();
                  },
                  child: Text(S.of(context).apply),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
