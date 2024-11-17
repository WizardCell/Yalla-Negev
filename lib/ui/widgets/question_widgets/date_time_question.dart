import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../models/surveys/question.dart';
import '../../../../utils/locale_helper.dart';
import '../../../generated/l10n.dart';
import '../../../providers/responses_provider.dart';

class DateTimeQuestion extends StatefulWidget {
  const DateTimeQuestion(
      {super.key, required this.question, required this.locale});

  final Question question;
  final SupportedLocale locale;

  @override
  DateTimeQuestionState createState() => DateTimeQuestionState();
}

class DateTimeQuestionState extends State<DateTimeQuestion> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        if (widget.question.type == QuestionType.dateTime) {
          _pickTime(context);
        } else {
          _updateResponse();
        }
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        if (widget.question.type == QuestionType.dateTime) {
          _selectedDate = DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
            _selectedTime!.hour,
            _selectedTime!.minute,
          );
        }
        _updateResponse();
      });
    }
  }

  void _updateResponse() {
    final responseProvider =
        Provider.of<ResponsesProvider>(context, listen: false);
    String responseValue = getFormattedDateTime();
    responseProvider.updateResponse(widget.question.id, responseValue);
  }

  String getFormattedDateTime() {
    final DateFormat dateFormatter = DateFormat.yMMMd();
    final DateFormat timeFormatter = DateFormat.jm();

    if (widget.question.type == QuestionType.dateTime) {
      if (_selectedDate != null) {
        return dateFormatter.format(_selectedDate!) +
            ' ' +
            timeFormatter.format(_selectedDate!);
      }
      return '';
    } else if (widget.question.type == QuestionType.date) {
      return _selectedDate != null ? dateFormatter.format(_selectedDate!) : '';
    } else if (widget.question.type == QuestionType.time) {
      return _selectedTime != null ? _selectedTime!.format(context) : '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLocalizedText(context, widget.question.text, widget.locale,
            theme.textTheme.bodyLarge),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            if (widget.question.type == QuestionType.date ||
                widget.question.type == QuestionType.dateTime) {
              _pickDate(context);
            } else if (widget.question.type == QuestionType.time) {
              _pickTime(context);
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: l10n.selectDateTime,
                suffixIcon: Icon(Icons.calendar_today),
              ),
              controller: TextEditingController(
                text: getFormattedDateTime(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
