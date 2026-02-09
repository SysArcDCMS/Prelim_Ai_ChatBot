import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonLocalizations extends ChangeNotifier {
  String _currentLangCode = 'en';
  Map<String, dynamic> _allTranslations = {};

  String get currentLangCode => _currentLangCode;

  // Load JSON once at start
  Future<void> loadJson() async {
    final jsonString =
    await rootBundle.loadString('assets/lang/language.json');
    _allTranslations = json.decode(jsonString);
    notifyListeners();
  }

  // Set current language
  void setLanguage(String langCode) {
    if (_currentLangCode == langCode) return;
    _currentLangCode = langCode;
    notifyListeners();
  }

  // Translate key
  String t(String key) {
    return _allTranslations[_currentLangCode]?[key] ?? key;
  }
}