import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yalla_negev/models/surveys/localized_text.dart';
import 'package:yalla_negev/providers/user_provider.dart';
import '../models/surveys/survey_response.dart';
import '../utils/globals.dart';
import 'bonus_provider.dart';

enum ResponsesProviderState { notLoaded, loading, loaded, error }

class ResponsesProvider with ChangeNotifier {
  final AuthRepository authRepository;
  late final BonusProvider? bonusProvider;

  Map<String, int> _responsesCount = {};
  Map<String, ResponsesProviderState> _status = {};
  Map<String, String> _errorMessages = {};
  Map<String, String> _responses = {};  // Keeping the existing responses field
  Map<String, List<SurveyResponse>> _userResponsesList = {}; // New field for user responses list

  Map<String, int> get responsesCount => _responsesCount;
  Map<String, ResponsesProviderState> get status => _status;
  Map<String, String> get errorMessages => _errorMessages;
  Map<String, String> get responses => _responses;  // Keeping the existing getter
  Map<String, List<SurveyResponse>> get userResponsesList => _userResponsesList; // Getter for new user responses list

  ResponsesProvider({required this.authRepository}) {
    bonusProvider = BonusProvider(authRepository: authRepository);
  }

  void updateResponse(String questionId, String response) {
    _responses[questionId] = response;
    notifyListeners();
  }

  Future<void> fetchNumberOfResponses(String surveyId) async {
    _status[surveyId] = ResponsesProviderState.loading;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await responsesCollection
          .where('surveyId', isEqualTo: surveyId)
          .get();
      _responsesCount[surveyId] = snapshot.docs.length;
      _status[surveyId] = ResponsesProviderState.loaded;
    } catch (e) {
      print('Error getting number of responses: $e');
      _status[surveyId] = ResponsesProviderState.error;
      _errorMessages[surveyId] = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchResponses(String surveyId) async {
    _status[surveyId] = ResponsesProviderState.loading;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await responsesCollection
          .where('surveyId', isEqualTo: surveyId)
          .get();

      _userResponsesList[surveyId] = snapshot.docs
          .map((doc) => SurveyResponse.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      _status[surveyId] = ResponsesProviderState.loaded;
    } catch (e) {
      print('Error fetching responses: $e');
      _status[surveyId] = ResponsesProviderState.error;
      _errorMessages[surveyId] = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> submitSurveyResponse(
      int points,
      LocalizedText pointsDescription,
      SurveyResponse surveyResponse,
      BuildContext context,
      ) async {
    try {
      // Submit the response
      // Don't await these operations, we want them to run just fine even if the user is offline!!!
      responsesCollection.add(surveyResponse.toMap());
      bonusProvider!.addPointsTransaction(pointsDescription, points);
    } catch (e) {
      print('Error submitting survey response: $e');
    }
  }

  Future<void> fetchResponseDetails(String responseId) async {
    try {
      DocumentSnapshot responseSnapshot = await responsesCollection.doc(responseId).get();
      if (responseSnapshot.exists) {
        SurveyResponse response = SurveyResponse.fromMap(responseSnapshot.data() as Map<String, dynamic>);
        _userResponsesList[responseId] = [response];
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching response details: $e');
    }
  }
}
