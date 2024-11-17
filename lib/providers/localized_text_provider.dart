import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import '../../../../models/surveys/localized_text.dart';

class LocalizedTextProvider extends ChangeNotifier {
  LocalizedText _localizedText;
  bool _isTranslating = false;
  String? _activeField;

  final GoogleTranslator _translator = GoogleTranslator();

  TextEditingController enController;
  TextEditingController heController;
  TextEditingController arController;

  LocalizedTextProvider(this._localizedText)
      : enController = TextEditingController(text: _localizedText.en),
        heController = TextEditingController(text: _localizedText.he),
        arController = TextEditingController(text: _localizedText.ar);

  LocalizedText get localizedText => _localizedText;
  bool get isTranslating => _isTranslating;
  String? get activeField => _activeField;

  void setActiveField(String field) {
    _activeField = field;
    notifyListeners();
  }

  Future<void> translate(String sourceLang, String fieldIdentifier) async {
    _isTranslating = true;
    notifyListeners();

    try {
      String translation1 = '';
      String translation2 = '';

      if (sourceLang == 'en') {
        translation1 = (await _translator.translate(enController.text, from: sourceLang, to: 'he')).text;
        translation2 = (await _translator.translate(enController.text, from: sourceLang, to: 'ar')).text;
      } else if (sourceLang == 'he') {
        translation1 = (await _translator.translate(heController.text, from: sourceLang, to: 'en')).text;
        translation2 = (await _translator.translate(heController.text, from: sourceLang, to: 'ar')).text;
      } else if (sourceLang == 'ar') {
        translation1 = (await _translator.translate(arController.text, from: sourceLang, to: 'en')).text;
        translation2 = (await _translator.translate(arController.text, from: sourceLang, to: 'he')).text;
      }

      if (fieldIdentifier == 'EN') {
        heController.text = translation1;
        arController.text = translation2;
        _localizedText = _localizedText.copyWith(he: translation1, ar: translation2);
      } else if (fieldIdentifier == 'HE') {
        enController.text = translation1;
        arController.text = translation2;
        _localizedText = _localizedText.copyWith(en: translation1, ar: translation2);
      } else if (fieldIdentifier == 'AR') {
        enController.text = translation1;
        heController.text = translation2;
        _localizedText = _localizedText.copyWith(en: translation1, he: translation2);
      }
    } finally {
      _isTranslating = false;
      notifyListeners();
    }
  }

  void saveText() {
    _localizedText = LocalizedText(
      en: enController.text,
      he: heController.text,
      ar: arController.text,
    );
    notifyListeners();
  }

  void disposeControllers() {
    enController.dispose();
    heController.dispose();
    arController.dispose();
    super.dispose();
  }
}
