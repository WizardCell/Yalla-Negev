import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'localized_text.dart';
import '../../utils/globals.dart';  // Importing the globals file

class ReportCategory {
  final String id;
  final LocalizedText typeTitle;
  final String icon;
  final DocumentReference? reportCategoryRef;

  ReportCategory({
    required this.id,
    required this.typeTitle,
    required this.icon,
    this.reportCategoryRef,
  });

  factory ReportCategory.fromMap(String id, Map<String, dynamic> data) {
    // The DocumentReference is derived from the path in Firestore using the global collection reference
    return ReportCategory(
      id: id,
      typeTitle: LocalizedText.fromMap(data['typeTitle']),
      icon: data['icon'] as String,
      reportCategoryRef: reportCategoriesCollection.doc(id),  // Using the global reference
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'typeTitle': typeTitle.toMap(),
      'icon': icon,
    };
  }

  String getLocalizedTitle(BuildContext context) {
    return typeTitle.getLocalizedText(context);
  }
}
