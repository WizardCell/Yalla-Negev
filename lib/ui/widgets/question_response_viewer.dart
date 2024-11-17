import 'package:flutter/material.dart';
import 'package:yalla_negev/models/surveys/question.dart';
import 'package:yalla_negev/generated/l10n.dart';

class QuestionResponseViewer extends StatelessWidget {
  final Question question;
  final String response;

  const QuestionResponseViewer({
    super.key,
    required this.question,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.text.getLocalizedText(context),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          _buildResponseField(context),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildResponseField(BuildContext context) {
    var l10n = S.of(context);

    switch (question.type) {
      case QuestionType.text:
      case QuestionType.multipleChoice:
      case QuestionType.numerical:
      case QuestionType.dateTime:
      case QuestionType.date:
      case QuestionType.time:
        return Text(
          response,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        );
      case QuestionType.yesNo:
        return Row(
          children: [
            Icon(
              response == 'true' ? Icons.check_circle : Icons.cancel,
              color: response == 'true' ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              response == 'true' ? l10n.yes : l10n.no,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        );
      case QuestionType.score:
        return Row(
          children: [
            Text(
              response,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.star,
              color: Colors.orange,
              size: 20,
            ),
          ],
        );
      default:
        return Container();
    }
  }
}
