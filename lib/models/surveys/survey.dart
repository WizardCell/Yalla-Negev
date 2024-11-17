import 'package:cloud_firestore/cloud_firestore.dart';
import 'question.dart';
import 'report_category.dart';
import 'localized_text.dart';
import '../../utils/globals.dart';

class Survey {
  final String id;
  final LocalizedText name;
  final LocalizedText description;
  final String graphicsUrl;
  final int maxPerUserTotal;
  final DateTime? archiveDateTime;
  final String creatorId;
  final String icon;
  final List<Question> questions;
  final DateTime endDateTime;
  final int points;
  final DateTime startDateTime;
  final DateTime creationDateTime;
  final int maxPerUserPerDay;
  final DocumentReference? reportCategoryRef;
  final ReportCategory? reportCategory;

  Survey({
    required this.id,
    required this.name,
    required this.description,
    required this.graphicsUrl,
    required this.maxPerUserTotal,
    this.archiveDateTime,
    required this.creatorId,
    required this.icon,
    required this.questions,
    required this.endDateTime,
    required this.points,
    required this.startDateTime,
    required this.creationDateTime,
    required this.maxPerUserPerDay,
    this.reportCategoryRef,
    this.reportCategory,
  });

  static Future<Survey> fromFirestore(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;

    DocumentReference? reportCategoryRef;
    ReportCategory? reportCategory;

    if (data.containsKey('reportCategory') && data['reportCategory'] is DocumentReference) {
      reportCategoryRef = data['reportCategory'] as DocumentReference?;

      if (reportCategoryRef != null) {
        final reportCategoryDoc = await reportCategoryRef.get();
        if (reportCategoryDoc.exists) {
          reportCategory = ReportCategory.fromMap(
            reportCategoryDoc.id,
            reportCategoryDoc.data() as Map<String, dynamic>,
          );
        }
      }
    }

    return Survey(
      id: doc.id,
      name: LocalizedText.fromMap(data['name']),
      description: LocalizedText.fromMap(data['description']),
      graphicsUrl: data['graphicsUrl'] ?? '',
      maxPerUserTotal: data['maxPerUserTotal'] ?? 0,
      archiveDateTime: data['archiveDateTime'] != null ? (data['archiveDateTime'] as Timestamp).toDate() : null,
      creatorId: data['creatorId'] ?? '',
      icon: data['icon'] ?? 'contact_support',
      questions: (data['questions'] as List<dynamic>)
          .map((question) => Question.fromMap(question as Map<String, dynamic>))
          .toList(),
      endDateTime: (data['endDateTime'] as Timestamp).toDate(),
      points: data['points'] ?? 0,
      startDateTime: (data['startDateTime'] as Timestamp).toDate(),
      creationDateTime: (data['creationDateTime'] as Timestamp).toDate(),
      maxPerUserPerDay: data['maxPerUserPerDay'] ?? 0,
      reportCategoryRef: reportCategoryRef,
      reportCategory: reportCategory,
    );
  }

  Survey copyWith({
    String? id,
    LocalizedText? name,
    LocalizedText? description,
    String? graphicsUrl,
    int? maxPerUserTotal,
    DateTime? archiveDateTime,
    String? creatorId,
    String? icon,
    List<Question>? questions,
    DateTime? endDateTime,
    int? points,
    DateTime? startDateTime,
    DateTime? creationDateTime,
    int? maxPerUserPerDay,
    DocumentReference? reportCategoryRef,
    ReportCategory? reportCategory,
  }) {
    return Survey(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      graphicsUrl: graphicsUrl ?? this.graphicsUrl,
      maxPerUserTotal: maxPerUserTotal ?? this.maxPerUserTotal,
      archiveDateTime: archiveDateTime ?? this.archiveDateTime,
      creatorId: creatorId ?? this.creatorId,
      icon: icon ?? this.icon,
      questions: questions ?? this.questions,
      endDateTime: endDateTime ?? this.endDateTime,
      points: points ?? this.points,
      startDateTime: startDateTime ?? this.startDateTime,
      creationDateTime: creationDateTime ?? this.creationDateTime,
      maxPerUserPerDay: maxPerUserPerDay ?? this.maxPerUserPerDay,
      reportCategoryRef: reportCategoryRef ?? this.reportCategoryRef,
      reportCategory: reportCategory ?? this.reportCategory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name.toMap(),
      'description': description.toMap(),
      'graphicsUrl': graphicsUrl,
      'maxPerUserTotal': maxPerUserTotal,
      'archiveDateTime': archiveDateTime,
      'creatorId': creatorId,
      'icon': icon,
      'questions': questions.map((question) => question.toMap()).toList(),
      'endDateTime': endDateTime,
      'points': points,
      'startDateTime': startDateTime,
      'creationDateTime': creationDateTime,
      'maxPerUserPerDay': maxPerUserPerDay,
      'reportCategory': reportCategoryRef,
    };
  }

  static Survey empty() {
    return Survey(
      id: '',
      name: LocalizedText.empty(),
      description: LocalizedText.empty(),
      graphicsUrl: '',
      maxPerUserTotal: 0,
      archiveDateTime: null,
      creatorId: '',
      icon: 'clipboardTextOutline',
      questions: [],
      endDateTime: DateTime.now(),
      points: 0,
      startDateTime: DateTime.now(),
      creationDateTime: DateTime.now(),
      maxPerUserPerDay: 0,
      reportCategoryRef: reportCategoriesCollection.doc('4RP7R98LiICxhC45uxyY'),
    );
  }
}
