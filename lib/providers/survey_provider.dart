import 'package:flutter/material.dart';
import 'package:yalla_negev/models/surveys/report_category.dart';
import '../models/surveys/survey.dart';
import '../utils/globals.dart';  // Importing globals for collection references

enum SurveysStatus { notLoaded, loading, loaded, error }

class SurveyProvider extends ChangeNotifier {
  List<Survey> _surveys = [];
  List<Survey> _filteredSurveys = [];
  List<ReportCategory> _reportCategories = [];
  SurveysStatus _status = SurveysStatus.notLoaded;
  String _searchQuery = '';
  final Set<String> _selectedCategoryIds = {};

  List<Survey> get surveys => _surveys;
  List<Survey> get filteredSurveys => _filteredSurveys;
  SurveysStatus get status => _status;
  List<ReportCategory> get reportCategories => _reportCategories;
  String get searchQuery => _searchQuery;
  Set<String> get selectedCategoryIds => _selectedCategoryIds;

  Future<void> getAllSurveys({bool includeInactive = false}) async {
    try {
      _status = SurveysStatus.loading;
      notifyListeners();

      // Query to get only the surveys where archiveDateTime is null
      var surveyDocsQuery = surveysCollection
          .where('archiveDateTime', isNull: true);

      if (!includeInactive) {
        surveyDocsQuery = surveyDocsQuery
            .where('startDateTime', isLessThanOrEqualTo: DateTime.now())
            .where('endDateTime', isGreaterThanOrEqualTo: DateTime.now());
      }

      var surveyDocs = await surveyDocsQuery.get();

      var reportCategoryDocs = await reportCategoriesCollection.get();  // Using global reference

      _reportCategories = reportCategoryDocs.docs.map((doc) {
        return ReportCategory.fromMap(doc.id, doc.data()!);
      }).toList();
      //sort report categories so that with the name "-" is always first
      _reportCategories.sort((a, b) => a.typeTitle.en!.compareTo(b.typeTitle.en!));

      _surveys = await Future.wait(surveyDocs.docs.map((doc) async {
        return await Survey.fromFirestore(doc);
      }).toList());

      _filteredSurveys = _surveys;
      _status = SurveysStatus.loaded;
    } catch (e) {
      _status = SurveysStatus.error;
      print('Error fetching surveys: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> saveSurvey(Survey survey) async {
    try {
      if (survey.id.isNotEmpty) {
        await surveysCollection.doc(survey.id).update(survey.toMap());
      } else {
        await surveysCollection.add(survey.toMap());
      }
      await getAllSurveys();
    } catch (e) {
      print('Error saving survey: $e');
    } finally {
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void updateSelectedCategories(String categoryPath) {
    if (_selectedCategoryIds.contains(categoryPath)) {
      _selectedCategoryIds.remove(categoryPath);
    } else {
      _selectedCategoryIds.add(categoryPath);
    }
    _applyFilters();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategoryIds.clear();
    _applyFilters();
  }

  void _applyFilters() {
    _filteredSurveys = _surveys.where((survey) {
      final matchesCategory = _selectedCategoryIds.isEmpty ||
          _selectedCategoryIds.contains(survey.reportCategory?.reportCategoryRef?.id);
      final matchesSearch = survey.name.en!.contains(_searchQuery) ||
          survey.name.he!.contains(_searchQuery) ||
          survey.name.ar!.contains(_searchQuery) ||
          survey.description.en!.contains(_searchQuery) ||
          survey.description.he!.contains(_searchQuery) ||
          survey.description.ar!.contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
    notifyListeners();
  }

  Survey? getSurveyById(String id) {
    return _surveys.firstWhere((survey) => survey.id == id,
        orElse: () => Survey.empty());
  }

  void notifySurveyUpdated(Survey survey) {
    int index = _surveys.indexWhere((s) => s.id == survey.id);
    if (index != -1) {
      _surveys[index] = survey;
      _applyFilters(); // Reapply filters if necessary
    }
    notifyListeners();
  }
}
