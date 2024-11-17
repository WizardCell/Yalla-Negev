import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/ui/screens/admin/surveys_manager/responses_stat.dart';
import 'package:yalla_negev/ui/screens/admin/surveys_manager/survey_editor.dart';
import 'package:yalla_negev/ui/screens/admin/surveys_manager/survey_preview.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/surveys/survey.dart';
import '../../../../navigation/routes.dart';
import '../../../../providers/survey_provider.dart';

class ManageSurveyScreen extends StatelessWidget {
  const ManageSurveyScreen({super.key, required this.survey});

  final Survey survey;

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          onDeleteConfirmed: () async {
            await _archiveSurvey(context);
            Navigator.of(context)
                .popAndPushNamed(AppRoutes.adminManageReportsRoute);
          },
        );
      },
    );
  }

  Future<void> _archiveSurvey(BuildContext context) async {
    final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
    final updatedSurvey = survey.copyWith(
      archiveDateTime: DateTime.now(),
    );

    await surveyProvider.saveSurvey(updatedSurvey);

    // Refresh the list of surveys and pop the current page
    await surveyProvider.getAllSurveys();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${l10n.manage} ${survey.name.en}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteConfirmationDialog(context),
              tooltip: l10n.deleteSurvey,
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.responses),
              Tab(text: l10n.preview),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ResponsesStat(surveyId: survey.id),
            PreviewTab(survey: survey),
          ],
        ),
      ),
    );
  }
}

class PreviewTab extends StatelessWidget {
  const PreviewTab({super.key, required this.survey});

  final Survey survey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SurveyPreview(surveyId: survey.id),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SurveyEditor(
              survey: survey,
              isNewSurvey: false,
            ),
          ));
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}

class DeleteConfirmationDialog extends StatefulWidget {
  final VoidCallback onDeleteConfirmed;

  const DeleteConfirmationDialog({super.key, required this.onDeleteConfirmed});

  @override
  DeleteConfirmationDialogState createState() =>
      DeleteConfirmationDialogState();
}

class DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  bool _isConfirmed = false;

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);

    return AlertDialog(
      title: Text(l10n.confirmDelete),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.deleteConfirmationText),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(l10n.swipeToConfirm),
              Expanded(
                child: Switch(
                  value: _isConfirmed,
                  onChanged: (value) {
                    setState(() {
                      _isConfirmed = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isConfirmed
              ? () {
                  widget.onDeleteConfirmed();
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: Text(l10n.delete),
        ),
      ],
    );
  }
}
