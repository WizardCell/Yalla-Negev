import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../../models/surveys/localized_text.dart';
import '../../../../models/surveys/question.dart';
import '../survey_editor/localized_text_field.dart';

class QuestionEditor extends StatelessWidget {
  final Question question;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final ValueSetter<Question> onValueChanged;

  const QuestionEditor({
    super.key,
    required this.question,
    required this.onRemove,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocalizedTextField(
            label: l10n.question,
            initialValue: question.text,
            onSaved: (value) {
              question.text = value;
              onValueChanged(question);
            },
          ),
          DropdownButton<QuestionType>(
            value: question.type,
            onChanged: (QuestionType? newValue) {
              question.type = newValue!;
              onValueChanged(question);
            },
            items: QuestionType.values.map<DropdownMenuItem<QuestionType>>((QuestionType value) {
              return DropdownMenuItem<QuestionType>(
                value: value,
                child: Text(value.toLocalizedString(context)),
              );
            }).toList(),
          ),
          if (question.type == QuestionType.score) ...[
            _buildNumberField(l10n.minValue, question.minValue, (value) {
              question.minValue = value;
              onValueChanged(question);
            }),
            _buildNumberField(l10n.maxValue, question.maxValue, (value) {
              question.maxValue = value;
              onValueChanged(question);
            }),
          ],
          if (question.type == QuestionType.multipleChoice) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                l10n.options,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Column(
              children: question.options!.map((option) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: LocalizedTextField(
                            label: l10n.option,
                            initialValue: option,
                            onSaved: (value) {
                              final index = question.options!.indexOf(option);
                              question.options![index] = value;
                              onValueChanged(question);
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            question.options!.remove(option);
                            onValueChanged(question);
                          },
                          tooltip: l10n.removeOption,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  question.options!.add(LocalizedText(en: '', he: '', ar: ''));
                  onValueChanged(question);
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.addOption),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onRemove,
                child: Text(l10n.removeQuestion, style: const TextStyle(color: Colors.red)),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    onPressed: onMoveUp,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: onMoveDown,
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.required),
              Checkbox(
                value: question.isRequired,
                onChanged: (value) {
                  question.isRequired = value!;
                  onValueChanged(question);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField(String label, int? initialValue, ValueSetter<int?> onSaved) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextFormField(
          initialValue: initialValue?.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: label),
          onSaved: (value) {
            onSaved(int.tryParse(value!));
            onValueChanged(question);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
