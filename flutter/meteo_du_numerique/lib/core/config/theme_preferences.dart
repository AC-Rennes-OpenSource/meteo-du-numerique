import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const _themeKey = "themeMode";
  static const _showBetaFeaturesKey = "showBetaFeatures";

  Future<void> setThemeMode(ThemeModePreference themeMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeMode.toString().split('.').last);
  }

  Future<void> setShowBetaFeatures(bool show) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showBetaFeaturesKey, show);
  }

  Future<ThemeModePreference> getThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String themeModeString = prefs.getString(_themeKey) ?? 'system';

    return ThemeModePreference.values.firstWhere(
      (element) => element.toString().split('.').last == themeModeString,
      orElse: () => ThemeModePreference.system,
    );
  }

  Future<bool> getShowBetaFeatures() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showBetaFeaturesKey) ?? false;
  }
}

enum ThemeModePreference {
  dark,
  light,
  system,
}

ThemeMode getThemeMode(ThemeModePreference preference) {
  switch (preference) {
    case ThemeModePreference.dark:
      return ThemeMode.dark;
    case ThemeModePreference.light:
      return ThemeMode.light;
    case ThemeModePreference.system:
      return ThemeMode.system;
  }
}