import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/ui/widgets/internet_connection/connection_alert.dart';
import 'package:yalla_negev/navigation/router.dart' as router;
import 'package:yalla_negev/utils/locale_helper.dart';
import 'package:yalla_negev/providers/all_main_providers.dart';

import '../generated/l10n.dart';
import '../navigation/navigation_service.dart';
import '../navigation/back_button_handler.dart';
import '../utils/setup_firebase_messaging.dart';

class MyYallaNegevAppWelcome extends StatefulWidget {
  const MyYallaNegevAppWelcome({super.key});

  static DateTime? lastForegroundMessageTime;

  @override
  MyYallaNegevAppWelcomeState createState() => MyYallaNegevAppWelcomeState();
}

class MyYallaNegevAppWelcomeState extends State<MyYallaNegevAppWelcome> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(BackButtonHandler().backButtonInterceptor);
    setupFirebaseMessaging(context);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(BackButtonHandler().backButtonInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        textDirection: TextDirection.ltr,
        children: [
          MaterialApp(
            title: 'Yalla Negev',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: router.generateRoute,
            theme: Provider.of<ThemeProvider>(context).getTheme,
            navigatorKey: NavigatorService.navigatorKey,
            locale: getLocaleFromSupportedLocale(
                Provider.of<LanguageProvider>(context).getLocale),
            localizationsDelegates: const [
              AppLocalizationDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: const [
              Locale('he', ''),
              Locale('ar', ''),
              Locale('en', '')
            ],
          ),
          const ConnectionAlert(),
        ],
      ),
    );
  }
}
