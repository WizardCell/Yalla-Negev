import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

enum QuestionType {
  yesNo,
  multipleChoice,
  text,
  score,
  numerical,
  dateTime,
  date,
  time;

  String toLocalizedString(BuildContext context) {
    var l10n = S.of(context);
    switch (this) {
      case QuestionType.yesNo:
        return l10n.yesNo;
      case QuestionType.multipleChoice:
        return l10n.multipleChoice;
      case QuestionType.text:
        return l10n.text;
      case QuestionType.score:
        return l10n.score;
      case QuestionType.numerical:
        return l10n.numerical;
      case QuestionType.dateTime:
        return l10n.dateTime;
      case QuestionType.date:
        return l10n.date;
      case QuestionType.time:
        return l10n.time;
      default:
        return l10n.unknown; // Ensure you handle a default case
    }
  }
}
