import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/providers/survey_provider.dart';
import 'package:yalla_negev/ui/screens/admin/surveys_manager/surveys_list_tile.dart';

enum SurveyListType {admin, clubMember}

class SurveysList extends StatelessWidget {
  const SurveysList({super.key, required this.listType});

  final SurveyListType listType;

  @override
  Widget build(BuildContext context) {
    return Consumer<SurveyProvider>(
      builder: (context, surveyProvider, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
          child: ListView.separated(
            itemCount: surveyProvider.filteredSurveys.length,
            itemBuilder: (context, index) {
              final survey = surveyProvider.filteredSurveys[index];
              return SurveysListTile(survey: survey, surveyListType: listType);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 4.0);
            },
          ),
        );
      },
    );
  }
}
