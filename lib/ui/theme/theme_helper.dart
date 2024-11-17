import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_style.dart';

class ThemeHelper {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primaryColor,
      primaryColorLight: AppColors.primaryColorLight,
      primaryColorDark: AppColors.primaryColorDark,
      hintColor: AppColors.accentColor,
      dividerColor: AppColors.accentColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      chipTheme: const ChipThemeData(
        backgroundColor: AppColors.surfaceColor,
        labelPadding: EdgeInsets.all(4.0),
        padding: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          side: BorderSide(
            color: AppColors.surfaceColor,
            width: 1.0,
          ),
        ),
        labelStyle: AppTextStyle.p4,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.primaryColor),
        thickness: WidgetStateProperty.all(3.0),
        radius: const Radius.circular(10),
      ),
      textTheme: const TextTheme(
        headlineLarge: AppTextStyle.h1,
        headlineMedium: AppTextStyle.h2,
        // TODO: Alexey, Add more text styles here
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.primaryColor,
        textTheme: ButtonTextTheme.primary,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryColor,
        linearTrackColor: AppColors.surfaceColor,
      ),


      cardTheme: const CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        elevation: 4,
        color: AppColors.backgroundColor,
      ),
      appBarTheme: const AppBarTheme(
        color: AppColors.primaryColor,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.onPrimaryColor, // Color of the selected tab text
        unselectedLabelColor:
            AppColors.onSurfaceColor, // Color of the unselected tab text
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.onPrimaryColor, // Color of the indicator
              width: 2.0,
            ),
          ),
        ),
      ),
      iconButtonTheme:  IconButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.all(8.0)),
          shape: WidgetStateProperty.all(const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            side: BorderSide(
              color: AppColors.primaryColor,
              width: 1.0,
            ),
          )),
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryColor,
        secondary: AppColors.accentColor,
        surface: AppColors.surfaceColor,
        error: AppColors.errorColor,
        onPrimary: AppColors.onPrimaryColor,
        onSecondary: AppColors.onSecondaryColor,
        onSurface: AppColors.onSurfaceColor,
        onError: AppColors.onErrorColor,
      ).copyWith(
        surface: AppColors.backgroundColor,
        error: AppColors.errorColor,
        background: AppColors.backgroundColor,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      hintColor: AppColors.accentDark,
      dividerColor: AppColors.accentDark,
      chipTheme: const ChipThemeData(
        backgroundColor: AppColors.surfaceDark,
        labelPadding: EdgeInsets.all(4.0),
        padding: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          side: BorderSide(
            color: AppColors.surfaceDark,
            width: 1.0,
          ),
        ),
        labelStyle: AppTextStyle.p4,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.primaryDark),
        thickness: WidgetStateProperty.all(3.0),
        radius: const Radius.circular(10),
      ),
      textTheme: const TextTheme(
        headlineLarge: AppTextStyle.h1,
        headlineMedium: AppTextStyle.h2,
        // TODO: Alexey, Add more text styles here
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.primaryDark,
        textTheme: ButtonTextTheme.primary,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryDark,
        linearTrackColor: AppColors.surfaceDark,
      ),
      cardTheme: const CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        elevation: 4,
        color: AppColors.surfaceDark,
      ),
      appBarTheme: const AppBarTheme(
        color: AppColors.primaryDark,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.onPrimary, // Color of the selected tab text
        unselectedLabelColor:
            AppColors.onSurface, // Color of the unselected tab text
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.onPrimary, // Color of the indicator
              width: 2.0,
            ),
          ),
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        secondary: AppColors.accentDark,
        surface: AppColors.surfaceDark,
        error: AppColors.errorColor,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.onSecondaryColor,
        onSurface: AppColors.onSurface,
        onError: AppColors.onErrorColor,
      ).copyWith(
        surface: AppColors.backgroundDark,
        error: AppColors.errorColor,
        background: AppColors.backgroundDark,

      ),
    );
  }
}
