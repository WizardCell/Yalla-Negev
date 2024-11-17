import 'package:flutter/widgets.dart';
import 'package:yalla_negev/ui/theme/app_colors.dart';

abstract class AppTextStyle {
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: 24,
    height: 1.17,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.12,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: 24,
    height: 1.17,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle p1 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: 18,
    height: 1.33,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
  );

  static const TextStyle p2 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
  );

  static const TextStyle p3 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: 16,
    height: 1.25,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle p4 = TextStyle(
      fontFamily: 'Rubik',
      fontSize: 14,
      height: 1.43,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurfaceColor);

  static const TextStyle p5 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: 14,
    height: 1.29,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle p6 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
  );

  static const TextStyle p7 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );
}
