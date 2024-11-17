import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/ui/screens/admin/surveys_manager/survey_editor.dart';
import 'package:yalla_negev/ui/screens/admin/surveys_manager/surveys_list.dart';
import 'package:yalla_negev/providers/survey_provider.dart';
import '../../../../../generated/l10n.dart';
import '../../../../models/surveys/survey.dart';

class ManageSurveysScreen extends StatelessWidget {
  const ManageSurveysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final surveyProvider =
          Provider.of<SurveyProvider>(context, listen: false);
      surveyProvider.getAllSurveys(includeInactive: true);
    });

    return Consumer<SurveyProvider>(
      builder: (context, surveyProvider, child) {
        switch (surveyProvider.status) {
          case SurveysStatus.notLoaded:
          case SurveysStatus.loading:
            return _buildLoadingIndicator();
          case SurveysStatus.loaded:
            return Scaffold(
              appBar: AppBar(
                title: Text(S.of(context).surveys,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context)
                      .unfocus(); // Hide the keyboard when tapping outside
                },
                child: Column(
                  children: [
                    _buildTopBar(context, surveyProvider),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await surveyProvider.getAllSurveys(
                              includeInactive: true);
                        },
                        child: const SurveysList(
                          listType: SurveyListType.admin,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SurveyEditor(
                      survey: Survey.empty(),
                      isNewSurvey: true,
                    ),
                  ));
                },
                child: const Icon(Icons.add),
              ),
            );
          case SurveysStatus.error:
          default:
            return _buildErrorIndicator(context);
        }
      },
    );
  }

  Widget _buildTopBar(BuildContext context, SurveyProvider surveyProvider) {
    var l10n = S.of(context);

    return Container(
      //margin: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //const SizedBox(height: 16),
          FocusScope(
            child: TextField(
              onChanged: (query) {
                surveyProvider.updateSearchQuery(query);
              },
              decoration: InputDecoration(
                hintText: l10n.search,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 8),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  showNotImplementedAlert(context);
                },
                child: Row(
                  children: [
                    const Icon(Icons.filter_list),
                    const SizedBox(width: 4),
                    Text(l10n.filter),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  surveyProvider.updateSearchQuery('');
                },
                child: Text(l10n.resetFilters),
              ),
            ],
          ),*/
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              l10n.showingSurveys(surveyProvider.filteredSurveys.length,
                  surveyProvider.surveys.length),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorIndicator(BuildContext context) {
    return Center(
      child: Text(S.of(context).error),
    );
  }
}
