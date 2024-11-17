import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/providers/language_provider.dart';
import '../generated/l10n.dart';
import '../models/surveys/localized_text.dart';
import '../models/users/user_role.dart';

enum SupportedLocale { en, he, ar }

/// Returns current locale
SupportedLocale getCurrentLocale(BuildContext context) {
  final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
  final currentLocale = languageProvider.getLocale;
  return currentLocale;
}

SupportedLocale getSupportedLocaleFromLocale(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return SupportedLocale.en;
    case 'he':
      return SupportedLocale.he;
    case 'ar':
      return SupportedLocale.ar;
    default:
      return SupportedLocale
          .en; // Default to English if locale is not supported
  }
}

Locale getLocaleFromSupportedLocale(SupportedLocale locale) {
  switch (locale) {
    case SupportedLocale.en:
      return const Locale('en', '');
    case SupportedLocale.he:
      return const Locale('he', '');
    case SupportedLocale.ar:
      return const Locale('ar', '');
  }
}

Locale getLocaleFromLanguage(String language) {
  switch (language) {
    case 'English':
      return const Locale('en', '');
    case 'Hebrew':
      return const Locale('he', '');
    case 'Arabic':
      return const Locale('ar', '');
    default:
      return getLocaleFromSupportedLocale(defaultLocale);
  }
}

String getLanguageFromLocale(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return 'English';
    case 'he':
      return 'Hebrew';
    case 'ar':
      return 'Arabic';
    default:
      return getLanguageFromSupportedLocale(defaultLocale);
  }
}

String getLanguageFromSupportedLocale(SupportedLocale locale) {
  switch (locale) {
    case SupportedLocale.en:
      return 'English';
    case SupportedLocale.he:
      return 'Hebrew';
    case SupportedLocale.ar:
      return 'Arabic';
  }
}

SupportedLocale getSupportedLocaleFromLanguage(String? language) {
  switch (language) {
    case 'English':
      return SupportedLocale.en;
    case 'Hebrew':
      return SupportedLocale.he;
    case 'Arabic':
      return SupportedLocale.ar;
    default:
      return defaultLocale;
  }
}

Widget buildLocalizedText(
  BuildContext context,
  LocalizedText localizedText,
  SupportedLocale locale,
  TextStyle? style, {
  int? maxLines,
  TextOverflow? overflow,
  TextAlign? textAlign,
}) {
  final texts = {
    SupportedLocale.en: localizedText.en,
    SupportedLocale.he: localizedText.he,
    SupportedLocale.ar: localizedText.ar,
  };

  final text = texts[locale] ?? texts[SupportedLocale.en];
  return Text(
    text ?? '',
    style: style,
    maxLines: maxLines,
    overflow: overflow,
    textAlign: textAlign,
  );
}

String getLocalizedUserRole(BuildContext context, UserRole role) {
  final l10n = S.of(context);
  switch (role) {
    case UserRole.user:
      return l10n.userRoleUser;
    case UserRole.clubMember:
      return l10n.userRoleClubMember;
    case UserRole.admin:
      return l10n.userRoleAdmin;
    default:
      return l10n.userRoleNone;
  }
}
