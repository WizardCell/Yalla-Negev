import 'question.dart';
import 'package:yalla_negev/utils/locale_helper.dart';

import 'localized_text.dart';
import 'survey.dart';

class LocalizedSurvey {
  final Survey survey;
  final SupportedLocale locale;

  LocalizedSurvey({required this.survey, required this.locale});

  String? get name {
    return _getLocalizedText(survey.name);
  }

  String? get description {
    return _getLocalizedText(survey.description);
  }

  List<LocalizedQuestion> get questions {
    return survey.questions
        .map((q) => LocalizedQuestion(question: q, locale: locale))
        .toList();
  }

  String? _getLocalizedText(LocalizedText text) {
    switch (locale) {
      case SupportedLocale.en:
        return text.en;
      case SupportedLocale.he:
        return text.he;
      case SupportedLocale.ar:
        return text.ar;
      default:
        return text.en;
    }
  }
}

class LocalizedQuestion {
  final Question question;
  final SupportedLocale locale;

  LocalizedQuestion({required this.question, required this.locale});

  String? get text {
    return _getLocalizedText(question.text);
  }

  QuestionType get type {
    return question.type;
  }

  String? _getLocalizedText(LocalizedText text) {
    switch (locale) {
      case SupportedLocale.en:
        return text.en;
      case SupportedLocale.he:
        return text.he;
      case SupportedLocale.ar:
        return text.ar;
      default:
        return text.en;
    }
  }
}
