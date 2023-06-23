import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppThemeProvider with ChangeNotifier {
  static int _selectedThemeIndex = 0;

  AppTheme _appTheme = appThemes[_selectedThemeIndex];

  AppTheme get appTheme => _appTheme;

  set appTheme(AppTheme value) {
    _appTheme = value;
    print("Setting ${appTheme.name}");
    notifyListeners();
  }

  cycleTheme() {
    _selectedThemeIndex++;
    if (_selectedThemeIndex > appThemes.length - 1) {
      _selectedThemeIndex = 0;
    }
    appTheme = appThemes[_selectedThemeIndex];
  }
}
