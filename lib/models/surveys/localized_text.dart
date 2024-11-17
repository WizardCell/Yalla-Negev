import 'package:flutter/material.dart';
import 'package:yalla_negev/utils/locale_helper.dart';

class LocalizedText {
  String? en;
  String? he;
  String? ar;

  LocalizedText({this.en, this.he, this.ar});

  factory LocalizedText.fromMap(Map<String, dynamic> data) {
    return LocalizedText(
      en: data['en'],
      he: data['he'],
      ar: data['ar'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'en': en,
      'he': he,
      'ar': ar,
    };
  }

  String getLocalizedText(BuildContext context) {
    final Locale appLocale = Localizations.localeOf(context);

    if (appLocale.languageCode == 'he') {
      return he ?? en ?? ar ?? '';
    } else if (appLocale.languageCode == 'ar') {
      return ar ?? en ?? he ?? '';
    } else {
      return en ?? he ?? ar ?? '';
    }
  }

  String of(SupportedLocale currentLocale) {
    switch (currentLocale) {
      case SupportedLocale.he:
        return he ?? en ?? ar ?? '';
      case SupportedLocale.ar:
        return ar ?? en ?? he ?? '';
      default:
        return en ?? he ?? ar ?? '';
    }
  }

  LocalizedText copyWith({String? en, String? he, String? ar}) {
    return LocalizedText(
      en: en ?? this.en,
      he: he ?? this.he,
      ar: ar ?? this.ar,
    );
  }

  static empty() {
    return LocalizedText(en: '', he: '', ar: '');
  }

  bool areAllValuesNotEmpty() {
    return (en != null && en!.isNotEmpty) &&
        (he != null && he!.isNotEmpty) &&
        (ar != null && ar!.isNotEmpty);
  }
}
