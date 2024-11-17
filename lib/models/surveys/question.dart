import 'question_type.dart';
import 'localized_text.dart';

export 'question_type.dart';

class Question {
  final String id; // The ID field
  LocalizedText text;
  QuestionType type;
  List<LocalizedText>? options;
  bool isRequired;
  int? minValue;
  int? maxValue;

  Question({
    required this.id, // Require the ID in the constructor
    required this.text,
    required this.type,
    this.options,
    this.isRequired = false,
    this.minValue,
    this.maxValue,
  });

  factory Question.fromMap(Map<String, dynamic> data) {
    return Question(
      id: data['id'] as String, // Retrieve the ID from the data
      text: LocalizedText.fromMap(data['text']),
      type: QuestionType.values[data['type']],
      options: data['options'] != null
          ? List<LocalizedText>.from(
          (data['options'] as List).map((item) => LocalizedText.fromMap(item)))
          : null,
      isRequired: data['isRequired'] as bool,
      minValue: data['minValue'] as int?,
      maxValue: data['maxValue'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Add the ID to the map
      'text': text.toMap(),
      'type': type.index,
      'options': options?.map((option) => option.toMap()).toList(),
      'isRequired': isRequired,
      'minValue': minValue,
      'maxValue': maxValue,
    };
  }

  Question copyWith({
    String? id,
    LocalizedText? text,
    QuestionType? type,
    List<LocalizedText>? options,
    bool? isRequired,
    int? minValue,
    int? maxValue,
  }) {
    return Question(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      options: options ?? this.options,
      isRequired: isRequired ?? this.isRequired,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
    );
  }
}
