import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:yalla_negev/models/surveys/survey.dart';
import 'package:yalla_negev/providers/survey_provider.dart';
import 'package:yalla_negev/ui/screens/admin/surveys_manager/question_editor.dart';
import 'package:yalla_negev/ui/screens/admin/survey_editor/localized_text_field.dart';
import 'package:yalla_negev/ui/screens/admin/survey_editor/date_picker_field.dart';
import 'package:yalla_negev/ui/screens/admin/survey_editor/number_field.dart';
import 'package:yalla_negev/ui/screens/admin/survey_editor/category_picker.dart';
import 'package:yalla_negev/ui/screens/admin/survey_editor/icon_picker.dart';
import 'package:yalla_negev/ui/screens/admin/survey_editor/image_uploader.dart';

import '../../../../generated/l10n.dart';
import '../../../../models/surveys/localized_text.dart';
import '../../../../models/surveys/question.dart';
import '../../../../providers/user_provider.dart';

class SurveyEditor extends StatefulWidget {
  final Survey survey;
  final bool isNewSurvey;

  const SurveyEditor(
      {super.key, required this.survey, required this.isNewSurvey});

  @override
  SurveyEditorState createState() => SurveyEditorState();
}

class SurveyEditorState extends State<SurveyEditor> {
  final _formKey = GlobalKey<FormState>();
  final Uuid uuid = Uuid();

  late LocalizedText _name;
  late LocalizedText _description;
  DateTime? _startDate;
  DateTime? _endDate;
  int? _maxPerUserTotal;
  int? _maxPerUserPerDay;
  int? _points;
  List<Question> _questions = [];
  DocumentReference? _selectedCategory;
  String? _selectedIcon;
  String? _imageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = widget.survey.name;
    _description = widget.survey.description;
    _startDate = widget.survey.startDateTime;
    _endDate = widget.survey.endDateTime;
    _maxPerUserTotal = widget.survey.maxPerUserTotal;
    _maxPerUserPerDay = widget.survey.maxPerUserPerDay;
    _points = widget.survey.points;
    _questions = widget.survey.questions;
    _selectedCategory = widget.survey.reportCategory?.reportCategoryRef;
    _selectedIcon = widget.survey.icon;
    _imageUrl = widget.survey.graphicsUrl;
  }

  Future<void> _saveSurvey(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });

      try {
        _formKey.currentState!.save();

        final authRepo = Provider.of<AuthRepository>(context, listen: false);

        Survey updatedSurvey = Survey(
          id: widget.survey.id,
          name: _name,
          description: _description,
          startDateTime: _startDate ?? DateTime.now(),
          endDateTime:
              _endDate ?? DateTime.now().add(const Duration(days: 1000)),
          maxPerUserTotal: _maxPerUserTotal ?? 0,
          maxPerUserPerDay: _maxPerUserPerDay ?? 0,
          points: _points ?? 10,
          questions: _questions,
          graphicsUrl: _imageUrl ?? '',
          creatorId: authRepo.uid,
          icon: _selectedIcon ?? '',
          creationDateTime: DateTime.now(),
          reportCategoryRef: _selectedCategory,
        );

        await Provider.of<SurveyProvider>(context, listen: false)
            .saveSurvey(updatedSurvey);

        Navigator.of(context).pop(); // Close the editor after saving
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).saveError)), // Display the error
        );
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).editorValidationError)),
      );
    }
  }

  void _updateLocalizedText(LocalizedText updatedText, bool isName) {
    setState(() {
      if (isName) {
        _name = updatedText;
      } else {
        _description = updatedText;
      }
    });
  }

  void _updateQuestion(int index, Question updatedQuestion) {
    setState(() {
      _questions[index] = updatedQuestion;
      _questions =
          List.from(_questions); // Replace with a new list to trigger rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);
    final _isNewSurvey = widget.isNewSurvey;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isNewSurvey ? l10n.addSurvey : l10n.editSurvey),
        actions: [
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: CircularProgressIndicator(
                    color: Colors.white, // Adjust color as needed
                  )
          )
              : IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    _saveSurvey(context);
                  },
                ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocalizedTextField(
                label: l10n.name,
                initialValue: _name,
                onSaved: (value) => _updateLocalizedText(value, true),
              ),
              LocalizedTextField(
                label: l10n.description,
                initialValue: _description,
                onSaved: (value) => _updateLocalizedText(value, false),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 12.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DatePickerField(
                              label: l10n.startDate,
                              selectedDate: _startDate,
                              onDateSelected: (date) => setState(() {
                                _startDate = date;
                              }),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DatePickerField(
                              label: l10n.endDate,
                              selectedDate: _endDate,
                              onDateSelected: (date) => setState(() {
                                _endDate = date;
                              }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      NumberField(
                        label: l10n.points,
                        initialValue: _points,
                        onSaved: (value) => _points = value,
                      ),
                    ],
                  ),
                ),
              ),
              /*Card(
                margin: const EdgeInsets.symmetric(vertical: 12.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildNumberFieldWithHelp(
                          context: context,
                          label: l10n.maxReportsPerUserTotalShort,
                          helperText: l10n.maxReportsPerUserTotal,
                          initialValue: _maxPerUserTotal,
                          onSaved: (value) => _maxPerUserTotal = value,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildNumberFieldWithHelp(
                          context: context,
                          label: l10n.maxReportsPerUserPerDayShort,
                          helperText: l10n.maxReportsPerUserPerDay,
                          initialValue: _maxPerUserPerDay,
                          onSaved: (value) => _maxPerUserPerDay = value,
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/
              CategoryPicker(
                selectedCategoryPath: _selectedCategory?.id,
                onCategorySelected: (categoryPath) {
                  setState(() {
                    _selectedCategory = categoryPath;
                  });
                },
              ),
              IconPicker(
                selectedIcon: _selectedIcon,
                onIconSelected: (icon) {
                  setState(() {
                    _selectedIcon = icon;
                  });
                },
              ),
              ImageUploader(
                initialImageUrl: _imageUrl,
                surveyId: widget.survey.id.isNotEmpty
                    ? widget.survey.id : uuid.v4(),
                onImageUploaded: (url) {
                  setState(() {
                    _imageUrl = url;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildQuestionsList(),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _addQuestion,
                  child: Text(l10n.addQuestion),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberFieldWithHelp({
    required BuildContext context,
    required String label,
    required String helperText,
    required int? initialValue,
    required ValueChanged<int?> onSaved,
  }) {
    var l10n = S.of(context);

    return Row(
      children: [
        Expanded(
          child: NumberField(
            label: label,
            initialValue: initialValue,
            onSaved: onSaved,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(l10n.help),
                content: Text(helperText),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.ok),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuestionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Questions',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final question = _questions.removeAt(oldIndex);
              _questions.insert(newIndex, question);
              _questions = List.from(
                  _questions); // Replace with a new list to trigger rebuild
            });
          },
          children: _questions.asMap().entries.map((entry) {
            int index = entry.key;
            Question question = entry.value;

            return QuestionEditor(
              key: ValueKey(question.id),
              // Ensure each question has a unique key
              question: question,
              onRemove: () => _removeQuestion(question.id),
              onMoveUp: () {
                int currentIndex = _questions.indexOf(question);
                if (currentIndex > 0) {
                  setState(() {
                    _questions.removeAt(currentIndex);
                    _questions.insert(currentIndex - 1, question);
                    _questions = List.from(_questions); // Trigger rebuild
                  });
                }
              },
              onMoveDown: () {
                int currentIndex = _questions.indexOf(question);
                if (currentIndex < _questions.length - 1) {
                  setState(() {
                    _questions.removeAt(currentIndex);
                    _questions.insert(currentIndex + 1, question);
                    _questions = List.from(_questions); // Trigger rebuild
                  });
                }
              },
              onValueChanged: (updatedQuestion) {
                _updateQuestion(index, updatedQuestion);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  void _addQuestion() {
    setState(() {
      _questions.add(Question(
        id: uuid.v4(),
        text: LocalizedText(en: '', he: '', ar: ''),
        type: QuestionType.yesNo,
        options: [],
        isRequired: false,
      ));
      _questions =
          List.from(_questions); // Replace with a new list to trigger rebuild
    });
  }

  void _removeQuestion(String questionId) {
    setState(() {
      _questions.removeWhere((question) => question.id == questionId);
      _questions =
          List.from(_questions); // Replace with a new list to trigger rebuild
    });
  }
}
