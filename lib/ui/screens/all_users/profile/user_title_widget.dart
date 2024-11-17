import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/providers/bonus_provider.dart';
import 'package:yalla_negev/ui/screens/all_users/profile/fullscreen_avatar.dart';

import '../../../../generated/l10n.dart';
import '../../../../models/users/user_data.dart';
import '../../../../utils/locale_helper.dart';

class UserTitleWidget extends StatelessWidget {
  const UserTitleWidget({super.key, required this.user});

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    BonusProvider bonusProvider =
        Provider.of<BonusProvider>(context, listen: true);

    return Column(children: [
      _buildHeader(context),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Chip(
            label: Text(
              "${user.points} ${l10n.points}",
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            avatar: Icon(
              Icons.star_rate_outlined,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Chip(
            label: Text(
              "${bonusProvider.getPositionByUserId(user.id)} ${l10n.inTheRanking}",
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            avatar: Icon(
              Icons.leaderboard,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          )
        ],
      )
    ]);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        user.pictureUrl == null
            ? const CircleAvatar(
                radius: 30,
                child: Icon(
                  Icons.person,
                  size: 30,
                ),
              )
            : GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return FullscreenAvatar(imageUrl: user.pictureUrl!);
                    },
                  );
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user.pictureUrl!),
                ),
              ),
        const SizedBox(width: 32),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.displayName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    getLocalizedUserRole(context, user.role),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 20,
                    child: _buildRoleIcon(user),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleIcon(UserData user) {
    if (user.role == UserRole.admin) {
      return const Icon(Icons.admin_panel_settings_outlined);
    } else if (user.role == UserRole.clubMember) {
      return const Icon(Icons.verified);
    }
    return Container();
  }
}
