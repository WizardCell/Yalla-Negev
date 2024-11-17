import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/providers/user_provider.dart';
import 'package:yalla_negev/utils/locale_helper.dart';

/// Default locale is the device's locale that is also supported by the app
final SupportedLocale defaultLocale =
    getSupportedLocaleFromLocale(PlatformDispatcher.instance.locale);

class LanguageProvider extends ChangeNotifier {
  SupportedLocale _locale;
  LanguageProvider(this._locale);

  // Current locale
  SupportedLocale get getLocale => _locale;

  void setLocale(dynamic locale) {
    if (locale is SupportedLocale) {
      _locale = locale;
      print('Language changed to: $locale');
    } else if (locale is String) {
      _locale = getSupportedLocaleFromLanguage(locale);
      print('Language changed to: $locale');
    } else {
      throw ArgumentError(
          'locale must be either a String or a SupportedLocale');
    }
    notifyListeners();
  }
}

class LanguageChangeNotifier
    extends ChangeNotifierProxyProvider<AuthRepository, LanguageProvider> {
  LanguageChangeNotifier({super.key})
      : super(
          create: (_) => LanguageProvider(defaultLocale),
          update: (_, authRepo, languageProvider) {
            languageProvider?.setLocale(
                getSupportedLocaleFromLanguage(authRepo.userData?.language));
            return languageProvider!;
          },
        );
}
