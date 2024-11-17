import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class SurveyResponse {
  final LatLng? coordinates;
  final String language;
  final int pointsCredited;
  final List<QuestionResponse> responses;
  final Timestamp submittedTs;
  final String surveyId;
  final String userId;

  SurveyResponse({
    required this.coordinates,
    required this.language,
    required this.pointsCredited,
    required this.responses,
    required this.submittedTs,
    required this.surveyId,
    required this.userId,
  });

  factory SurveyResponse.fromMap(Map<String, dynamic> data) {
    return SurveyResponse(
      coordinates: data['coordinates'] != null
          ? LatLng(
        data['coordinates']['latitude'] as double,
        double.parse(data['coordinates']['longitude']),
      )
          : null,
      language: data['language'] as String,
      pointsCredited: data['pointsCredited'] as int,
      responses: (data['responses'] as List)
          .map((item) => QuestionResponse.fromMap(item))
          .toList(),
      submittedTs: data['submittedTs'] as Timestamp,
      surveyId: data['surveyId'] as String,
      userId: data['userId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'coordinates': coordinates != null
          ? {
        'latitude': coordinates!.latitude,
        'longitude': coordinates!.longitude.toString(),
      }
          : null,
      'language': language,
      'pointsCredited': pointsCredited,
      'responses': responses.map((response) => response.toMap()).toList(),
      'submittedTs': submittedTs,
      'surveyId': surveyId,
      'userId': userId,
    };
  }
}

class QuestionResponse {
  final String questionId;
  final String response;

  QuestionResponse({
    required this.questionId,
    required this.response,
  });

  factory QuestionResponse.fromMap(Map<String, dynamic> data) {
    return QuestionResponse(
      questionId: data['questionId'] as String,
      response: data['response'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'response': response,
    };
  }

  static empty() {
    return QuestionResponse(questionId: '', response: '');
  }
}
