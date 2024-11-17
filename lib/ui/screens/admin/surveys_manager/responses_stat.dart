import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/generated/l10n.dart';
import 'package:yalla_negev/providers/responses_provider.dart';
import 'package:yalla_negev/models/surveys/survey_response.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/survey_response_viewer.dart';

class ResponsesStat extends StatefulWidget {
  final String surveyId;

  const ResponsesStat({super.key, required this.surveyId});

  @override
  ResponsesStatState createState() => ResponsesStatState();
}

class ResponsesStatState extends State<ResponsesStat> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<ResponsesProvider>(context, listen: false)
          .fetchResponses(widget.surveyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);
    return Consumer<ResponsesProvider>(
      builder: (context, responsesProvider, child) {
        final status = responsesProvider.status[widget.surveyId] ?? ResponsesProviderState.notLoaded;
        final numberOfResponses = responsesProvider.responsesCount[widget.surveyId] ?? 0;
        final errorMessage = responsesProvider.errorMessages[widget.surveyId] ?? 'Unknown error';
        final responsesList = responsesProvider.userResponsesList[widget.surveyId] ?? [];

        switch (status) {
          case ResponsesProviderState.loading:
            return const Center(
              child: SpinKitWanderingCubes(
                color: AppColors.primaryColor,
                size: 50.0,
              ),
            );
          case ResponsesProviderState.error:
            return Center(child: Text('${l10n.errorLoadingResponses}: $errorMessage'));
          case ResponsesProviderState.loaded:
            return RefreshIndicator(
              onRefresh: () => responsesProvider.fetchResponses(widget.surveyId),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '${l10n.numberOfResponses}: ${responsesList.length}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  ...responsesList.map((response) => Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.person, color: Theme.of(context).primaryColor),
                      title: Text(
                        l10n.submittedOn(DateFormat('MMMM dd, yyyy – hh:mm a').format(response.submittedTs.toDate())),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text('${l10n.userId}: ${response.userId}'),
                      trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurveyResponseViewer(surveyResponse: response),
                          ),
                        );
                      },
                    ),
                  ))
                ],
              ),
            );
          default:
            return Center(child: Text(l10n.noDataLoaded));
        }
      },
    );
  }
}
