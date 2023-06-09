import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode waveThemeMode = ThemeMode.dark;

  setWaveThemeMode(ThemeMode themeMode) {
    waveThemeMode = themeMode;
    notifyListeners();
  }
}
