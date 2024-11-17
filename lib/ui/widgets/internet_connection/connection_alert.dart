import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/providers/connectivity_provider.dart';

class ConnectionAlert extends StatefulWidget {
  const ConnectionAlert({super.key});

  @override
  ConnectionAlertState createState() => ConnectionAlertState();
}

class ConnectionAlertState extends State<ConnectionAlert> {
  bool wasOffline = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!connectivity.isOnline) {
            // Show a simple notification when the device is offline
            showSimpleNotification(
              const Text('No internet connection!',
                  style: TextStyle(color: Colors.white)),
              background: Colors.red,
            );
            wasOffline = true;
          } else if (wasOffline) {
            // Show a different notification when the device is back online
            showSimpleNotification(
              const Text('Internet connection restored!',
                  style: TextStyle(color: Colors.white)),
              background: Colors.green,
            );
            wasOffline = false;
          }
        });
        return const SizedBox.shrink();
      },
    );
  }
}
