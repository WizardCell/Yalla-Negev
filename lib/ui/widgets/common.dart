import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

void showNotImplementedAlert(BuildContext context) {
  var l10n = S.of(context);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.error),
        content: Text(l10n.filtersNotImplemented),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(l10n.confirm),
          ),
        ],
      );
    },
  );
}