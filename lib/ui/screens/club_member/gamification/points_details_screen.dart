import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/gamification/points_transaction.dart';
import '../../../../providers/bonus_provider.dart';
import '../../../theme/app_colors.dart';

class PointsDetailsScreen extends StatefulWidget {
  const PointsDetailsScreen({super.key});

  @override
  _PointsDetailsScreenState createState() => _PointsDetailsScreenState();
}

class _PointsDetailsScreenState extends State<PointsDetailsScreen> {
  late Future<List<PointsTransaction>> _pointsHistoryFuture;

  @override
  void initState() {
    super.initState();
    _pointsHistoryFuture = _loadPointsHistory();
  }

  Future<List<PointsTransaction>> _loadPointsHistory() {
    return Provider.of<BonusProvider>(context, listen: false)
        .fetchPointsHistory();
  }

  Future<void> _refreshPointsHistory() async {
    setState(() {
      _pointsHistoryFuture = _loadPointsHistory();
    });
    await _pointsHistoryFuture;
  }

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.pointsDetails,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<BonusProvider>(
        builder: (context, bonusProvider, child) {
          int totalPoints = bonusProvider.points;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTotalPointsCard(totalPoints, context),
                const SizedBox(height: 20),
                Text(
                  l10n.pointsHistory,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder<List<PointsTransaction>>(
                    future: _pointsHistoryFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SpinKitWanderingCubes(
                              color: AppColors.primaryColor,
                              size: 50.0,
                            ),
                            const SizedBox(height: 20),
                            Text(l10n.loadingPointsHistory),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(l10n.failedToLoadPointsHistory),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(l10n.noPointsHistoryAvailable),
                        );
                      } else {
                        List<PointsTransaction> pointsHistory = snapshot.data!;
                        return RefreshIndicator(
                          onRefresh: _refreshPointsHistory,
                          child: ListView.builder(
                            itemCount: pointsHistory.length,
                            itemBuilder: (context, index) {
                              var entry = pointsHistory[index];
                              return _buildPointsHistoryItem(entry, context);
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Center(
                //   child: ElevatedButton(
                //     onPressed: () {
                //       showDialog(
                //         context: context,
                //         builder: (context) => AlertDialog(
                //           title: Text(l10n.redeemPoints),
                //           content: Text(l10n.redeemNotSupported),
                //           actions: [
                //             TextButton(
                //               onPressed: () => Navigator.of(context).pop(),
                //               child: Text('OK'),
                //             ),
                //           ],
                //         ),
                //       );
                //     },
                //     child: Text(l10n.redeemPoints),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalPointsCard(int totalPoints, BuildContext context) {
    var l10n = S.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.star,
              size: 50,
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 10),
            Text(
              l10n.totalPoints(totalPoints),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsHistoryItem(
      PointsTransaction entry, BuildContext context) {
    var l10n = S.of(context);

    // Format the timestamp to a human-readable format
    String formattedDate = DateFormat.yMMMd().add_jm().format(entry.ts);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        leading: Icon(
          entry.points >= 0
              ? Icons.add_circle_outline
              : Icons.remove_circle_outline,
          color:
              entry.points >= 0 ? AppColors.successColor : AppColors.errorColor,
          size: 30, // Smaller and more elegant icon size
        ),
        title: Text(
          entry.description.getLocalizedText(context),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(formattedDate), // Formatted date
        trailing: Text(
          '${entry.points} ${l10n.points}',
          style: TextStyle(
            color: entry.points >= 0
                ? AppColors.successColor
                : AppColors.errorColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
