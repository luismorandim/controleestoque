import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';

class LanguageManager extends ChangeNotifier {
  Locale _locale = const Locale('pt', 'BR');

  Locale get locale => _locale;

  void changeLanguage(String languageCode) {
    if (languageCode == 'en') {
      _locale = const Locale('en', 'US');
      I18n.define(Locale("en", "US"));
    } else if (languageCode == 'pt') {
      _locale = const Locale('pt', 'BR');
      I18n.define(Locale("pt", "BR"));
    }
    notifyListeners();
  }
}
