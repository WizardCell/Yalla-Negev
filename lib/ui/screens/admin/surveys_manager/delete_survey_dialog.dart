import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';

class DeleteConfirmationDialog extends StatefulWidget {
  final Future<void> Function() onDeleteConfirmed;

  const DeleteConfirmationDialog({Key? key, required this.onDeleteConfirmed})
      : super(key: key);

  @override
  _DeleteConfirmationDialogState createState() =>
      _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  bool _isConfirmed = false;
  bool _isLoading = false;

  Future<void> _handleDelete() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onDeleteConfirmed();
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(S.of(context).saveError)), // Replace with localized string
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);

    return AlertDialog(
      title: Text(l10n.confirmDelete),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.deleteConfirmationText),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(l10n.swipeToConfirm),
              Expanded(
                child: Switch(
                  value: _isConfirmed,
                  onChanged: (value) {
                    setState(() {
                      _isConfirmed = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        _isLoading
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  color: Colors.red, // Adjust color as needed
                ),
              )
            : ElevatedButton(
                onPressed: _isConfirmed ? _handleDelete : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(l10n.delete),
              ),
      ],
    );
  }
}
