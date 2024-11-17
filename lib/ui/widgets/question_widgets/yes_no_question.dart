import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/surveys/question.dart';
import '../../../../utils/locale_helper.dart';
import '../../../generated/l10n.dart';
import '../../../providers/responses_provider.dart';

class YesNoQuestion extends StatelessWidget {
  final Question question;
  final SupportedLocale locale;

  const YesNoQuestion({super.key, required this.question, required this.locale});

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);
    final theme = Theme.of(context);
    final responseProvider = Provider.of<ResponsesProvider>(context);

    // Retrieve the current value from the provider and parse it as a boolean
    final currentValue = responseProvider.responses[question.id] == 'true'
        ? true
        : responseProvider.responses[question.id] == 'false'
            ? false
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLocalizedText(
            context, question.text, locale, theme.textTheme.bodyLarge),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: Text(l10n.yes),
                value: true,
                groupValue: currentValue,
                onChanged: (value) {
                  responseProvider.updateResponse(
                      question.id, value.toString());
                },
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: Text(l10n.no),
                value: false,
                groupValue: currentValue,
                onChanged: (value) {
                  responseProvider.updateResponse(
                      question.id, value.toString());
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
