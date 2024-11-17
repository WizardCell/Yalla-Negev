import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/providers/language_provider.dart';
import 'package:yalla_negev/providers/theme_provider.dart';
import 'package:yalla_negev/providers/user_provider.dart';
import 'package:yalla_negev/utils/locale_helper.dart';

import '../../../../generated/l10n.dart';
import '../../../theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  late String _selectedLanguage;
  late bool _prefersDarkTheme;
  late List<String> _languages;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var l10n = S.of(context);
      _languages = [l10n.english, l10n.hebrew, l10n.arabic];
      _selectedLanguage = _languages.first;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);
    var user = Provider.of<AuthRepository>(context, listen: false);
    var themeProvider = Provider.of<ThemeProvider>(context);
    var languageProvider = Provider.of<LanguageProvider>(context);

    Map<String, String> languageMap = {
      'English': 'English',
      'Hebrew': 'Hebrew - עברית',
      'Arabic': 'Arabic - العربية',
    };
    _prefersDarkTheme = themeProvider.getTheme == darkTheme;
    _selectedLanguage =
        getLanguageFromSupportedLocale(languageProvider.getLocale);

    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            // Language Setting
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 16.0,
                ),
                leading: const Icon(
                    Icons.language, color: AppColors.accentColor),
                title: Text(
                    l10n.language,
                    style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                trailing: DropdownButton<String>(
                  value: _selectedLanguage,
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  underline: Container(),
                  items: languageMap.entries.map<DropdownMenuItem<String>>((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                    });

                    languageProvider.setLocale(
                        getSupportedLocaleFromLanguage(_selectedLanguage));

                    user.updateUserData(newLanguage: _selectedLanguage);
                  },
                ),
              ),
            ),
            // Theme Setting
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 16.0,
                ),
                secondary: const Icon(
                    Icons.brightness_6, color: AppColors.accentColor),
                title: Text(l10n.darkTheme,
                    style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                value: _prefersDarkTheme,
                onChanged: (bool isOn) {
                  setState(() {
                    _prefersDarkTheme = isOn;
                  });

                  themeProvider
                      .setTheme(_prefersDarkTheme ? darkTheme : lightTheme);

                  user.updateUserData(newPrefersDarkTheme: _prefersDarkTheme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
