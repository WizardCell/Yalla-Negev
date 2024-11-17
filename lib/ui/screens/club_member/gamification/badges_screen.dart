import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/generated/l10n.dart';
import 'package:yalla_negev/models/gamification/yalla_badge.dart';
import 'package:yalla_negev/providers/bonus_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../theme/app_colors.dart';

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  BadgesScreenState createState() => BadgesScreenState();
}

class BadgesScreenState extends State<BadgesScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when the screen is first opened
    _fetchData();
  }

  Future<void> _fetchData({bool isForce = false}) async {
    await Provider.of<BonusProvider>(context, listen: false)
        .fetchBonusData(isForce: isForce);
  }

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.badges,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<BonusProvider>(
        builder: (context, bonusProvider, child) {
          return FutureBuilder<List<YallaBadge>>(
            future: bonusProvider.fetchAvailableBadges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SpinKitWanderingCubes(
                    color: AppColors.primaryColor,
                    size: 50.0,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text(l10n.failedToLoadBadges));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text(l10n.noBadgesAvailable));
              } else {
                List<YallaBadge> badges = snapshot.data!;
                return FutureBuilder<List<EarnedBadge>>(
                  future: bonusProvider.fetchEarnedBadges(),
                  builder: (context, earnedSnapshot) {
                    if (earnedSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: SpinKitWanderingCubes(
                          color: AppColors.primaryColor,
                          size: 50.0,
                        ),
                      );
                    } else if (earnedSnapshot.hasError) {
                      return Center(child: Text(l10n.failedToLoadBadges));
                    } else {
                      List<EarnedBadge> earnedBadges =
                          earnedSnapshot.data ?? [];
                      int badgesCollected = earnedBadges.length;
                      int totalBadges = badges.length;

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _buildSummaryCard(
                                l10n, badgesCollected, totalBadges),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () => _fetchData(isForce: true),
                              child: GridView.builder(
                                padding: const EdgeInsets.all(16.0),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 16.0,
                                  mainAxisSpacing: 16.0,
                                  childAspectRatio:
                                      0.8, // Adjust aspect ratio for vertical layout
                                ),
                                itemCount: badges.length,
                                itemBuilder: (context, index) {
                                  YallaBadge badge = badges[index];
                                  bool isEarned = earnedBadges.any(
                                      (earnedBadge) =>
                                          earnedBadge.badgeId == badge.id);
                                  return GestureDetector(
                                    onTap: () =>
                                        _showBadgeDescription(context, badge),
                                    child: _buildBadgeItem(
                                        context, badge, isEarned),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(S l10n, int badgesCollected, int totalBadges) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const Icon(
              Icons.badge,
              size: 50,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                l10n.badgesCollected(badgesCollected, totalBadges),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeItem(
      BuildContext context, YallaBadge badge, bool isEarned) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: isEarned
              ? LinearGradient(
                  colors: _getGradientColors(badge.id),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isEarned ? null : Colors.grey[300],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                MdiIcons.fromString(badge.icon),
                size: 50,
                color: isEarned ? Colors.white : Colors.grey[600],
              ),
              const SizedBox(height: 10),
              Text(
                badge.name.getLocalizedText(context),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isEarned ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center, // Center text to handle multiline
                maxLines: 2, // Limit to two lines
                overflow: TextOverflow.ellipsis, // Handle overflow
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBadgeDescription(BuildContext context, YallaBadge badge) {
    var l10n = S.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(badge.name.getLocalizedText(context)),
          content: Text(badge.description.getLocalizedText(context)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }

  List<Color> _getGradientColors(String badgeId) {
    final int hash = badgeId.hashCode;
    final Color color1 = Color((hash & 0xFFFFFF) | 0xFF000000).withOpacity(0.8);
    final Color color2 =
        Color(((hash >> 8) & 0xFFFFFF) | 0xFF000000).withOpacity(0.8);
    return [color1, color2];
  }
}
