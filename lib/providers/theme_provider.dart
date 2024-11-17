import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/providers/user_provider.dart';
import 'package:yalla_negev/ui/theme/theme_helper.dart';

final darkTheme = ThemeHelper.darkTheme;
final lightTheme = ThemeHelper.lightTheme;

// Default theme is based on device settings
final defaultTheme =
    PlatformDispatcher.instance.platformBrightness == Brightness.dark
        ? darkTheme
        : lightTheme;

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;
  ThemeProvider(this._themeData);

  // Current theme
  ThemeData get getTheme => _themeData;

  void setTheme(ThemeData theme) {
    _themeData = theme;
    print('Theme changed to: $theme');
    notifyListeners();
  }
}

class ThemeChangeNotifier
    extends ChangeNotifierProxyProvider<AuthRepository, ThemeProvider> {
  ThemeChangeNotifier({super.key})
      : super(
          create: (_) => ThemeProvider(defaultTheme),
          update: (_, authRepo, themeProvider) {
            if (authRepo.userData == null) {
              themeProvider = ThemeProvider(defaultTheme);
            }
            themeProvider!.setTheme(authRepo.userData?.prefersDarkTheme == true
                ? darkTheme
                : lightTheme);
            return themeProvider;
          },
        );
}

/// Returns current theme
ThemeData getCurrentTheme(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  final currentTheme = themeProvider.getTheme;
  return currentTheme;
}

bool prefersDarkTheme(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  return themeProvider.getTheme == darkTheme;
}
