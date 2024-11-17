import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/surveys/question.dart';
import '../../../../utils/locale_helper.dart';
import '../../../providers/responses_provider.dart';

class ScoreQuestion extends StatefulWidget {
  const ScoreQuestion(
      {super.key, required this.question, required this.locale});

  final Question question;
  final SupportedLocale locale;

  @override
  ScoreQuestionState createState() => ScoreQuestionState();
}

class ScoreQuestionState extends State<ScoreQuestion> {
  double _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.question.minValue?.toDouble() ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responseProvider = Provider.of<ResponsesProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLocalizedText(context, widget.question.text, widget.locale,
            theme.textTheme.bodyLarge),
        const SizedBox(height: 8),
        Slider(
          value: _currentValue,
          min: widget.question.minValue?.toDouble() ?? 0,
          max: widget.question.maxValue?.toDouble() ?? 10,
          divisions: (widget.question.maxValue ?? 10) -
              (widget.question.minValue ?? 0),
          label: _currentValue.round().toString(),
          onChanged: (value) {
            setState(() {
              _currentValue = value;
            });
            responseProvider.updateResponse(
                widget.question.id, value.toString());
          },
        ),
      ],
    );
  }
}
