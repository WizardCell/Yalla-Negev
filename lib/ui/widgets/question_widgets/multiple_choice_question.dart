import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/surveys/question.dart';
import '../../../../utils/locale_helper.dart';
import '../../../providers/responses_provider.dart';

class MultipleChoiceQuestion extends StatefulWidget {
  const MultipleChoiceQuestion(
      {super.key, required this.question, required this.locale});

  final Question question;
  final SupportedLocale locale;

  @override
  MultipleChoiceQuestionState createState() => MultipleChoiceQuestionState();
}

class MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  String? _selectedOption;

  void _updateResponse(String selectedOption) {
    final responseProvider =
        Provider.of<ResponsesProvider>(context, listen: false);
    _selectedOption = selectedOption;
    responseProvider.updateResponse(widget.question.id, selectedOption);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLocalizedText(context, widget.question.text, widget.locale,
            theme.textTheme.bodyLarge),
        const SizedBox(height: 8),
        Column(
          children: widget.question.options
                  ?.map((option) => RadioListTile<String>(
                        title: buildLocalizedText(context, option,
                            widget.locale, theme.textTheme.bodyMedium),
                        value: option.getLocalizedText(context),
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _updateResponse(value);
                            });
                          }
                        },
                      ))
                  .toList() ??
              [],
        ),
      ],
    );
  }
}
