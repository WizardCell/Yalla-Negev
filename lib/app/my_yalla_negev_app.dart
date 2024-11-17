import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/app/yalla_negev_app_welcome.dart';
import 'package:yalla_negev/providers/all_main_providers.dart';

import '../providers/responses_provider.dart';

class MyYallaNegevApp extends StatelessWidget {
  const MyYallaNegevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalConfigProvider>(
          create: (_) => GlobalConfigProvider()..fetchGlobalConfig(),
        ),
        ChangeNotifierProvider<AuthRepository>(
          create: (_) => AuthRepository.instance(),
        ),
        ChangeNotifierProvider<NavigationProvider>(
          create: (_) => NavigationProvider(),
        ),
        ChangeNotifierProvider<ConnectivityProvider>(
          create: (_) => ConnectivityProvider(),
        ),
        ChangeNotifierProvider<SurveyProvider>(
          create: (_) => SurveyProvider(),
        ),
        ChangeNotifierProxyProvider<AuthRepository, BonusProvider>(
          create: (context) => BonusProvider(
              authRepository:
              Provider.of<AuthRepository>(context, listen: false)),
          update: (context, authRepo, bonusProvider) =>
          bonusProvider!..updateAuthRepository(authRepo),
        ),
        ChangeNotifierProxyProvider<AuthRepository, ThemeProvider>(
          create: (_) => ThemeProvider(defaultTheme),
          update: (_, authRepo, themeProvider) {
            if (authRepo.userData == null ||
                authRepo.userData?.prefersDarkTheme == null) {
              themeProvider = ThemeProvider(defaultTheme);
            }
            themeProvider!.setTheme(authRepo.userData?.prefersDarkTheme == true
                ? darkTheme
                : lightTheme);
            return themeProvider;
          },
        ),
        ChangeNotifierProxyProvider<AuthRepository, LanguageProvider>(
          create: (_) => LanguageProvider(defaultLocale),
          update: (_, authRepo, languageProvider) {
            languageProvider!
                .setLocale(authRepo.userData?.language ?? defaultLocale);
            return languageProvider;
          },
        ),
      ],
      child: Builder(
        builder: (context) =>
            MultiProvider(
                providers: [
                  ChangeNotifierProvider<ResponsesProvider>(
                    create: (_) => ResponsesProvider(
                        authRepository: Provider.of<AuthRepository>(context, listen: false)),
                  )
                ],
                child: const MyYallaNegevAppWelcome()
            )
      ),
    );
  }
}