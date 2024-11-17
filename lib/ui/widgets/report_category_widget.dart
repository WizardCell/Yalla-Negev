import 'package:flutter/material.dart';
import 'package:yalla_negev/models/surveys/localized_text.dart';
import 'package:yalla_negev/ui/theme/app_colors.dart';

class ReportCategoryWidget extends StatelessWidget {
  final IconData icon;
  final LocalizedText title;
  final bool isSelected;

  const ReportCategoryWidget({
    super.key,
    required this.icon,
    required this.title,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent.withOpacity(0.2)
              : Theme.of(context).brightness == Brightness.light
              ? AppColors.lightThemeColor
              : AppColors.darkThemeColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          Text(
            title.getLocalizedText(context),
            softWrap: true,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.onBackgroundColor
                  : AppColors.lightThemeColor,
            ),
          ),
        ],
      ),
    );
  }
}
