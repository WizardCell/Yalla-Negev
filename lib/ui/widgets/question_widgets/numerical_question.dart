import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/surveys/question.dart';
import '../../../../utils/locale_helper.dart';
import '../../../generated/l10n.dart';
import '../../../providers/responses_provider.dart';

class NumericalQuestion extends StatelessWidget {
  const NumericalQuestion(
      {super.key, required this.question, required this.locale});

  final Question question;
  final SupportedLocale locale;

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);
    final theme = Theme.of(context);
    final responseProvider = Provider.of<ResponsesProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLocalizedText(
            context, question.text, locale, theme.textTheme.bodyLarge),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: l10n.enterANumber),
          onChanged: (value) {
            responseProvider.updateResponse(question.id, value);
          },
        ),
      ],
    );
  }
}
