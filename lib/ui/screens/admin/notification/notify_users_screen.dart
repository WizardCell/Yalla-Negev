import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/generated/l10n.dart';
import 'package:yalla_negev/ui/screens/admin/notification/notification_manager.dart';
import 'package:yalla_negev/ui/theme/app_colors.dart';

class NotifyUsersScreen extends StatefulWidget {
  const NotifyUsersScreen({super.key});

  @override
  NotifyUsersScreenState createState() => NotifyUsersScreenState();
}

class NotifyUsersScreenState extends State<NotifyUsersScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _imageUrl = '';
  bool _isSending = false;

  Future<void> _sendNotificationToAllUsers() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });
      _formKey.currentState?.save();

      try {
        await NotificationManager.sendNotification(
            _title, _description, _imageUrl);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).notificationSentSuccess),
            backgroundColor: AppColors.successColor,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.of(context).notificationSentFailed}: $e'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      } finally {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifyUsers,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: l10n.notificationTitle,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.enterTitle;
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: l10n.notificationDescription,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.enterDescription;
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: l10n.imageUrlOptional,
                  border: const OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _imageUrl = value ?? '';
                },
              ),
              const SizedBox(height: 24),
              _isSending
                  ? const Center(
                      child: SpinKitThreeBounce(
                        color: AppColors.primaryColor,
                        size: 40.0,
                      ),
                    )
                  : ElevatedButton(
                      onPressed: _sendNotificationToAllUsers,
                      child: Text(l10n.sendNotification),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
