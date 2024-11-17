import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yalla_negev/generated/l10n.dart';
import 'package:yalla_negev/models/surveys/localized_survey.dart';
import 'package:yalla_negev/models/surveys/survey_response.dart';

import '../../../../models/surveys/survey.dart';
import '../../../../utils/globals.dart';
import '../../../../utils/locale_helper.dart';
import '../../../widgets/survey_response_viewer.dart';

class ReportRow extends StatelessWidget {
  final DocumentSnapshot document;
  final int index;

  const ReportRow({
    super.key,
    required this.document,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    SurveyResponse surveyResponse = SurveyResponse.fromMap(data);
    Timestamp timestamp = surveyResponse.submittedTs;
    DateTime date = timestamp.toDate();
    String formattedDate = DateFormat('h:mm a | dd/MM/yyyy').format(date);

    return FutureBuilder<LocalizedSurvey?>(
      future: getLocalizedSurvey(context, surveyResponse.surveyId),
      builder: (BuildContext context, AsyncSnapshot<LocalizedSurvey?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('${l10n.error}: ${snapshot.error}');
        } else if (snapshot.data == null) {
          return Container();
        } else {
          String surveyTitle = snapshot.data!.name ?? '';
          String surveyDescription = snapshot.data!.description ?? '';

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurveyResponseViewer(
                    surveyResponse: surveyResponse,
                  ),
                ),
              );
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: const BoxDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.submittedOn(formattedDate),
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.light
                                    ? const Color(0xFF815A2B)
                                    : Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${index + 1}. $surveyTitle',
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.light
                                    ? const Color(0xFF1D1B20)
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              surveyDescription,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.light
                                    ? const Color(0xFF49454F)
                                    : Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFFCAC4D0), thickness: 1),
              ],
            ),
          );
        }
      },
    );
  }

  Future<LocalizedSurvey?> getLocalizedSurvey(
      BuildContext context, String surveyId) async {
    try {
      DocumentSnapshot surveyDocument = await surveysCollection.doc(surveyId).get();
      if (!surveyDocument.exists) {
        print('Survey $surveyId does not exist');
        return null;
      }
      Survey survey = await Survey.fromFirestore(surveyDocument);
      return LocalizedSurvey(survey: survey, locale: getCurrentLocale(context));
    } catch (e) {
      print('Error fetching survey: $e');
      return null;
    }
  }
}
