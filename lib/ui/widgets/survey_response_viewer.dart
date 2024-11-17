import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/providers/survey_provider.dart';
import 'package:yalla_negev/models/surveys/question.dart';
import 'package:yalla_negev/models/surveys/survey_response.dart';
import 'package:yalla_negev/ui/widgets/question_response_viewer.dart';
import 'package:yalla_negev/generated/l10n.dart';

class SurveyResponseViewer extends StatelessWidget {
  final SurveyResponse surveyResponse;

  const SurveyResponseViewer({
    super.key,
    required this.surveyResponse,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).surveyResponse,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Consumer<SurveyProvider>(
        builder: (context, surveyProvider, child) {
          final survey = surveyProvider.getSurveyById(surveyResponse.surveyId);

          if (survey == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMetadataSection(context),
                const SizedBox(height: 16),
                _buildResponsesSection(survey.questions),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetadataSection(BuildContext context) {
    var l10n = S.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetadataItem(
              icon: Icons.location_on,
              label: l10n.coordinates,
              value: _formatCoordinates(surveyResponse.coordinates),
            ),
            _buildMetadataItem(
              icon: Icons.language,
              label: l10n.language,
              value: surveyResponse.language,
            ),
            _buildMetadataItem(
              icon: Icons.star,
              label: l10n.pointsCredited,
              value: surveyResponse.pointsCredited.toString(),
            ),
            _buildMetadataItem(
              icon: Icons.access_time,
              label: l10n.submitted,
              value: _formatTimestamp(surveyResponse.submittedTs),
            ),
            _buildMetadataItem(
              icon: Icons.assignment,
              label: l10n.surveyId,
              value: surveyResponse.surveyId,
            ),
            /*_buildMetadataItem(
              icon: Icons.person,
              label: l10n.userId,
              value: surveyResponse.userId,
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsesSection(List<Question> questions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Responses:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...questions.map((question) {
          final response = surveyResponse.responses.firstWhere(
            (resp) => resp.questionId == question.id,
            orElse: () => QuestionResponse.empty(),
          );
          return QuestionResponseViewer(
              question: question, response: response.response);
        }).toList(),
      ],
    );
  }

  String _formatCoordinates(LatLng? coordinates) {
    if (coordinates == null) return 'N/A';
    return '(${coordinates.latitude}, ${coordinates.longitude})';
  }

  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat.yMMMd().add_jm().format(date);
  }
}
