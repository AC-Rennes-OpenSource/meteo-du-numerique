import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/saved_preferences.dart';

// Enum déplacé directement dans ce fichier pour simplifier
enum ThemeEvent { toggleForecastsVisibility, toggleLight, toggleDark, toggleSystem }

class ThemeState {
  final bool showForecasts;
  final ThemeData themeData;
  final ThemeMode themeMode;
  final ThemeEvent currentTheme;

  ThemeState({required this.showForecasts, required this.themeData, required this.themeMode, required this.currentTheme});

  bool get isDarkMode => themeData.brightness == Brightness.dark;
}

class ThemeCubit extends Cubit<ThemeState> {
  final String themePrefKey = 'selected_theme';
  final String forecastsPrefKey = 'show_forecasts';

  // Variable statique pour accéder à l'état des prévisions de manière synchrone
  static bool _forecastsVisibility = false;

  ThemeCubit() : super(ThemeState(showForecasts: false, themeData: lightTheme, themeMode: ThemeMode.system, currentTheme: ThemeEvent.toggleSystem)) {
    _loadThemePreferences();
  }

  void toggleForecastsVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    final showForecasts = !state.showForecasts;
    final themePreferences = SavedPreferences();
    themePreferences.setShowBetaFeatures(showForecasts);
    prefs.setBool(forecastsPrefKey, showForecasts);

    // Pour les apps qui attendent une réponse synchrone, mettre à jour la valeur en cache
    _forecastsVisibility = showForecasts;

    emit(ThemeState(themeData: state.themeData, themeMode: state.themeMode, currentTheme: state.currentTheme, showForecasts: showForecasts));
  }

  void toggleLightTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(themePrefKey, 'light');

    emit(ThemeState(themeData: lightTheme, themeMode: ThemeMode.light, currentTheme: ThemeEvent.toggleLight, showForecasts: state.showForecasts));
  }

  void toggleDarkTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(themePrefKey, 'dark');

    emit(ThemeState(themeData: darkTheme, themeMode: ThemeMode.dark, currentTheme: ThemeEvent.toggleDark, showForecasts: state.showForecasts));
  }

  void toggleSystemTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(themePrefKey, 'system');

    final window = WidgetsBinding.instance.platformDispatcher;
    final brightness = window.platformBrightness;
    final themeData = brightness == Brightness.dark ? darkTheme : lightTheme;

    emit(ThemeState(themeData: themeData, themeMode: ThemeMode.system, currentTheme: ThemeEvent.toggleSystem, showForecasts: state.showForecasts));
  }

  void _loadThemePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themePref = prefs.getString(themePrefKey) ?? 'system';

    final themePreferences = SavedPreferences();
    final showBetaFeatures = await themePreferences.getShowBetaFeatures();
    if (showBetaFeatures) {
      toggleForecastsVisibility();
    }

    switch (themePref) {
      case 'light':
        toggleLightTheme();
        break;
      case 'dark':
        toggleDarkTheme();
        break;
      default:
        toggleSystemTheme();
    }
  }

  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Marianne-Regular',
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Marianne-Regular',
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: Colors.blue),
  );
}
