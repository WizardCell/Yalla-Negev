import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/navigation/navigation_service.dart';
import 'package:yalla_negev/utils/assets_helper.dart';
import '../../../../navigation/routes.dart';
import 'leaderboard_screen.dart';
import 'package:yalla_negev/ui/screens/club_member/gamification/badges_screen.dart';
import 'points_details_screen.dart';
import '../../../../generated/l10n.dart';
import '../../../../providers/bonus_provider.dart';
import '../../../theme/app_colors.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  RewardsScreenState createState() => RewardsScreenState();
}

class RewardsScreenState extends State<RewardsScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      //_refreshData(context, isForce: true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _refreshData(BuildContext context,
      {bool isForce = false}) async {
    await Provider.of<BonusProvider>(context, listen: false)
        .fetchBonusData(isForce: isForce);
  }

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Transparency
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                AssetsHelper.welcomeBackground,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main Content with Pull-to-Refresh, Centered Cards, and Padding
          Consumer<BonusProvider>(
            builder: (context, bonusProvider, child) {
              if (!bonusProvider.dataFetched) {
                // Fetch data if not fetched
                bonusProvider.fetchBonusData();
              }

              int points = bonusProvider.points;
              int badgesCollected = bonusProvider.badgesCollected;
              int totalBadges = bonusProvider.totalBadges;
              int leaderboardPosition = bonusProvider.leaderboardPosition;

              return RefreshIndicator(
                onRefresh: () => _refreshData(context, isForce: true),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    // Padding from left and right
                    child: ListView(
                      shrinkWrap: true,
                      // This makes the ListView as small as possible
                      children: [
                        _buildCard(
                          context,
                          l10n.youHavePoints(points),
                          Icons.star,
                          AppColors.primaryColor,
                          () {
                            NavigatorService.pushNamed(
                                AppRoutes.pointsDetailsRoute);
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildCard(
                          context,
                          l10n.badgesCollected(badgesCollected, totalBadges),
                          Icons.badge,
                          AppColors.accentColor,
                          () {
                            NavigatorService.pushNamed(
                                AppRoutes.badgesRoute);
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildCard(
                          context,
                          l10n.leaderboardPosition(leaderboardPosition),
                          Icons.leaderboard,
                          AppColors.successColor,
                          () {
                            NavigatorService.pushNamed(AppRoutes.leaderboardRoute);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String text,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 50,
                color: iconColor,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
