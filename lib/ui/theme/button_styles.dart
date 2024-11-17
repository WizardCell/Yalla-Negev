import 'package:flutter/material.dart';

import 'app_colors.dart';

class ButtonStyles {
  static const double buttonWidth = 250.0;
  static const double buttonWidthWider = 300;

  // TODO: There should button styles for dark theme and light theme, and then it's just a matter of using them in theme_helper.dart... I think?
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: const Color.fromRGBO(255, 165, 0, 0.7),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    textStyle: const TextStyle(fontSize: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  static final ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.orange,
    backgroundColor: AppColors.backgroundColor,
    side: const BorderSide(color: Colors.orange),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    textStyle: const TextStyle(fontSize: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
