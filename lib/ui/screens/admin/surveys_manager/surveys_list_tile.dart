import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:yalla_negev/providers/theme_provider.dart';
import 'package:yalla_negev/ui/screens/admin/surveys_manager/manage_survey_screen.dart';
import 'package:yalla_negev/ui/screens/admin/surveys_manager/surveys_list.dart';
import 'package:yalla_negev/ui/screens/club_member/reports/fill_survey_screen.dart';

import '../../../../generated/l10n.dart';
import '../../../../models/surveys/localized_survey.dart';
import '../../../../models/surveys/survey.dart';
import '../../../../utils/locale_helper.dart';
import '../../../../navigation/routes.dart';

class SurveysListTile extends StatelessWidget {
  const SurveysListTile({
    super.key,
    required this.survey,
    required this.surveyListType,
  });

  final Survey survey;
  final SurveyListType surveyListType;

  @override
  Widget build(BuildContext context) {
    var preferredLocale = Localizations.localeOf(context);
    var l10n = S.of(context);
    var theme = Theme.of(context);

    final localizedSurvey = LocalizedSurvey(
      survey: survey,
      locale: getSupportedLocaleFromLocale(preferredLocale),
    );

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: getCurrentTheme(context).primaryColorLight,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () => _onTap(context, surveyListType),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                child: Icon(
                  MdiIcons.fromString(survey.icon),
                  size: 32.0,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            localizedSurvey.name ?? '',
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star_rate_outlined,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '+${survey.points}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      localizedSurvey.description ?? '',
                      style: theme.textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            survey.reportCategory?.typeTitle
                                    .getLocalizedText(context) ??
                                l10n.category,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${localizedSurvey.questions.length} ${l10n.questions.toLowerCase()}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, SurveyListType surveyListType) {
    var route = surveyListType == SurveyListType.admin
        ? MaterialPageRoute(
            builder: (context) => ManageSurveyScreen(survey: survey,),
    )
        : MaterialPageRoute(
            builder: (context) => FillSurveyScreen(survey: survey,),
    );

    Navigator.push(context, route);
  }
}
