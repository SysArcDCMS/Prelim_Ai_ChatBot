import 'package:flutter/material.dart';
import 'app_themes.dart';

class ThemeNotifier extends ChangeNotifier {
  AppTheme _currentTheme = AppTheme.defaultTheme;

  AppTheme get currentTheme => _currentTheme;

  ThemeData get themeData {
    switch (_currentTheme) {
      case AppTheme.light:
        return AppThemes.lightTheme;
      case AppTheme.dark:
        return AppThemes.darkTheme;
      case AppTheme.defaultTheme:
      default:
        return AppThemes.defaultTheme;
    }
  }

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}
