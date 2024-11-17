import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/providers/bonus_provider.dart';
import 'package:yalla_negev/models/users/user_data.dart';
import 'package:yalla_negev/generated/l10n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../theme/app_colors.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  LeaderboardScreenState createState() => LeaderboardScreenState();
}

class LeaderboardScreenState extends State<LeaderboardScreen> {
  final GlobalKey _currentUserKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  bool _isCurrentUserVisible = false;
  bool _isPinnedAtTop = false;
  final double _itemHeight = 100.0; // Approximate height of each list item

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialPositionCheck();
      _checkCurrentUserVisibility();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshLeaderboard(); // Fetch data when the screen is first opened
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshLeaderboard() async {
    final bonusProvider = Provider.of<BonusProvider>(context, listen: false);
    await bonusProvider.fetchLeaderboard(); // Using the correct refresh method
  }

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);
    final bonusProvider = Provider.of<BonusProvider>(context);

    if (bonusProvider.isLeaderboardLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.leaderboard,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(
          child: SpinKitWanderingCubes(
            color: AppColors.primaryColor,
            size: 50.0,
          ),
        ),
      );
    }

    final leaderboardUsers = bonusProvider.leaderboardUsers;
    final currentUser = leaderboardUsers.firstWhere(
      (user) => user.id == bonusProvider.authRepository.uid,
      orElse: () => UserData.empty(),
    );
    final currentUserIndex = leaderboardUsers.indexOf(currentUser);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.leaderboard,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_pin_circle),
            onPressed: () {
              _scrollToCurrentUser(currentUserIndex);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshLeaderboard,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification) {
                  _checkCurrentUserVisibility();
                }
                return true;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: leaderboardUsers.length,
                  itemBuilder: (context, index) {
                    UserData user = leaderboardUsers[index];
                    bool isCurrentUser = user.id == currentUser.id;

                    return Card(
                      key: isCurrentUser ? _currentUserKey : null,
                      color: _getCardColor(isCurrentUser),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10.0),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.pictureUrl ?? ''),
                          radius: 30,
                        ),
                        title: Text(
                          user.displayName,
                          style: TextStyle(
                            fontWeight: isCurrentUser
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 18,
                            color: AppColors.onSurfaceColor,
                          ),
                        ),
                        subtitle: Text(
                          '${l10n.points}: ${user.points}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: _buildRankBadge(index),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          if (!_isCurrentUserVisible)
            _buildStickyCurrentUserTile(context, currentUser, currentUserIndex),
        ],
      ),
    );
  }

  void _scrollToCurrentUser(int index) {
    _scrollController.animateTo(
      index * _itemHeight,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _initialPositionCheck() {
    final renderObject = _currentUserKey.currentContext?.findRenderObject();
    if (renderObject != null && renderObject is RenderBox) {
      final currentUserPosition = renderObject.localToGlobal(Offset.zero).dy;
      final screenMidPoint = MediaQuery.of(context).size.height / 2;

      setState(() {
        _isPinnedAtTop = currentUserPosition < screenMidPoint;
        _isCurrentUserVisible = currentUserPosition >= 0 &&
            currentUserPosition <= MediaQuery.of(context).size.height;
      });
    }
  }

  void _checkCurrentUserVisibility() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderObject? renderObject =
          _currentUserKey.currentContext?.findRenderObject();
      if (renderObject != null && renderObject is RenderBox) {
        final currentUserPosition = renderObject.localToGlobal(Offset.zero).dy;
        final screenHeight = MediaQuery.of(context).size.height;
        final visibility =
            currentUserPosition >= 0 && currentUserPosition <= screenHeight;
        final isPinnedAtTop = currentUserPosition < screenHeight / 2;

        if (visibility != _isCurrentUserVisible ||
            isPinnedAtTop != _isPinnedAtTop) {
          setState(() {
            _isCurrentUserVisible = visibility;
            _isPinnedAtTop = isPinnedAtTop;
          });
        }
      }
    });
  }

  Widget _buildStickyCurrentUserTile(
      BuildContext context, UserData currentUser, int index) {
    return Positioned(
      top: _isPinnedAtTop ? 0 : null,
      bottom: !_isPinnedAtTop ? 0 : null,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () => _scrollToCurrentUser(index),
        child: Material(
          elevation: 5,
          color: AppColors.backgroundColor.withOpacity(0.85),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10.0),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(currentUser.pictureUrl ?? ''),
              radius: 30,
            ),
            title: Text(
              currentUser.displayName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.onSurfaceColor,
              ),
            ),
            subtitle: Text(
              '${S.of(context).points}: ${currentUser.points}',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            trailing: _buildRankBadge(index),
          ),
        ),
      ),
    );
  }

  Color _getCardColor(bool isCurrentUser) {
    return isCurrentUser ? AppColors.surfaceColor : Colors.white;
  }

  Widget _buildRankBadge(int index) {
    if (index == 0) {
      return Icon(
        MdiIcons.trophy,
        color: Colors.amber,
        size: 30,
      );
    } else if (index == 1) {
      return Icon(
        MdiIcons.trophy,
        color: Colors.grey,
        size: 30,
      );
    } else if (index == 2) {
      return Icon(
        MdiIcons.trophy,
        color: Colors.brown,
        size: 30,
      );
    } else {
      return Text(
        '#${index + 1}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      );
    }
  }
}
