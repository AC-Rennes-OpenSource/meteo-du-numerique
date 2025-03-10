import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/presentation/theme/theme_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/theme_preferences.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final String themePrefKey = 'selected_theme';
  final String forecastsPrefKey = 'show_forecasts';
  
  // Variable statique pour accéder à l'état des prévisions de manière synchrone
  static bool _forecastsVisibility = false;

  ThemeBloc() : super(ThemeState(
      showForecasts: false,
      themeData: lightTheme,
      themeMode: ThemeMode.system,
      currentTheme: ThemeEvent.toggleSystem)) {

    on<ThemeEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      ThemeData themeData = state.themeData;
      ThemeMode themeMode = state.themeMode;
      String themePrefValue = prefs.getString(themePrefKey) ?? 'system';
      bool showForecasts = prefs.getBool(forecastsPrefKey) ?? false;

      if (event == ThemeEvent.toggleForecastsVisibility) {
        showForecasts = !state.showForecasts;
        final themePreferences = ThemePreferences();
        themePreferences.setShowBetaFeatures(showForecasts);
        prefs.setBool(forecastsPrefKey, showForecasts);
        
        // Pour les apps qui attendent une réponse synchrone, mettre à jour la valeur en cache
        _forecastsVisibility = showForecasts;

        emit(ThemeState(
            themeData: state.themeData,
            themeMode: state.themeMode,
            currentTheme: state.currentTheme,
            showForecasts: showForecasts
        ));
      } else if (event == ThemeEvent.toggleLight) {
        themeData = lightTheme;
        themeMode = ThemeMode.light;
        themePrefValue = 'light';
        prefs.setString(themePrefKey, themePrefValue);

        emit(ThemeState(
            themeData: themeData,
            themeMode: themeMode,
            currentTheme: event,
            showForecasts: state.showForecasts
        ));
      } else if (event == ThemeEvent.toggleDark) {
        themeData = darkTheme;
        themeMode = ThemeMode.dark;
        themePrefValue = 'dark';
        prefs.setString(themePrefKey, themePrefValue);

        emit(ThemeState(
            themeData: themeData,
            themeMode: themeMode,
            currentTheme: event,
            showForecasts: state.showForecasts
        ));
      } else if (event == ThemeEvent.toggleSystem) {
        final window = WidgetsBinding.instance.platformDispatcher;
        final brightness = window.platformBrightness;
        themeData = brightness == Brightness.dark ? darkTheme : lightTheme;
        themeMode = ThemeMode.system;
        themePrefValue = 'system';
        prefs.setString(themePrefKey, themePrefValue);

        emit(ThemeState(
            themeData: themeData,
            themeMode: themeMode,
            currentTheme: event,
            showForecasts: state.showForecasts
        ));
      }
    });

    _loadThemePreferences();
  }

  void _loadThemePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themePref = prefs.getString(themePrefKey) ?? 'system';

    final themePreferences = ThemePreferences();
    final showBetaFeatures = await themePreferences.getShowBetaFeatures();
    if (showBetaFeatures) {
      add(ThemeEvent.toggleForecastsVisibility);
    }

    switch (themePref) {
      case 'light':
        add(ThemeEvent.toggleLight);
        break;
      case 'dark':
        add(ThemeEvent.toggleDark);
        break;
      default:
        add(ThemeEvent.toggleSystem);
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