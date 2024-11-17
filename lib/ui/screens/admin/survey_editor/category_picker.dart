import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/providers/survey_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:yalla_negev/generated/l10n.dart';

import '../../../../models/surveys/report_category.dart';

class CategoryPicker extends StatelessWidget {
  final String? selectedCategoryPath;
  final ValueSetter<DocumentReference?> onCategorySelected;

  const CategoryPicker({
    Key? key,
    required this.selectedCategoryPath,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);  // Localized strings

    // Fetch the current selected category
    final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
    final selectedCategory = selectedCategoryPath != null
        ? surveyProvider.reportCategories.firstWhere(
          (cat) => cat.reportCategoryRef?.id == selectedCategoryPath,
      orElse: () => surveyProvider.reportCategories.firstWhere(
            (cat) => cat.getLocalizedTitle(context) == '-',
      ),
    )
        : surveyProvider.reportCategories.firstWhere(
          (cat) => cat.getLocalizedTitle(context) == '-',
    );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("${l10n.pickCategory}: ", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () => _showCategoryPickerDialog(context),
              icon: Row(
                children: [
                  Icon(
                    MdiIcons.fromString(selectedCategory.icon),
                    size: 36,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    selectedCategory.getLocalizedTitle(context),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              tooltip: l10n.category,
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<SurveyProvider>(
          builder: (context, surveyProvider, child) {
            // Sort the list so that "-" category is the first item
            final categories = surveyProvider.reportCategories
              ..sort((a, b) {
                if (a.getLocalizedTitle(context) == '-') return -1;
                if (b.getLocalizedTitle(context) == '-') return 1;
                return a.getLocalizedTitle(context).compareTo(b.getLocalizedTitle(context));
              });

            return AlertDialog(
              title: Text(S.of(context).pickCategory),
              content: Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return ListTile(
                      leading: Icon(MdiIcons.fromString(category.icon)),
                      title: Text(category.getLocalizedTitle(context)),
                      onTap: () {
                        onCategorySelected(category.reportCategoryRef);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
