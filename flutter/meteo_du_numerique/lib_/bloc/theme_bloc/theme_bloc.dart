import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/bloc/theme_bloc/theme_event.dart';
import 'package:meteo_du_numerique/bloc/theme_bloc/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/theme_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final String themePrefKey = 'selectedTheme';
  final String prevPrefKey = 'previsionKey';


  ThemeBloc()
      : super(ThemeState(themeData: lightTheme, themeMode: ThemeMode.system, currentTheme: ThemeEvent.toggleSystem, showPrevision: false)) {
    on<ThemeEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final themePreferences = ThemePreferences();
      ThemeData themeData = lightTheme;
      ThemeMode themeMode = ThemeMode.system;
      String themePrefValue = 'system';
      bool showPrevision = false;

      if (event == ThemeEvent.toggleLight) {
          themeData = lightTheme;
          themeMode = ThemeMode.light;
          themePrefValue = 'light';
      } else if (event == ThemeEvent.toggleDark) {
          themeData = darkTheme;
          themeMode = ThemeMode.dark;
          themePrefValue = 'dark';
      } else if (event == ThemeEvent.toggleSystem) {
          final brightness = WidgetsBinding.instance.window.platformBrightness;
          themeData = brightness == Brightness.dark ? darkTheme : lightTheme;
          themeMode = ThemeMode.system;
          themePrefValue = 'system';
      } else if (event == ThemeEvent.showPrevision) {

        showPrevision = !showPrevision;
         themePreferences.setShowBetaFeatures(showPrevision);
        prefs.setBool(prevPrefKey, showPrevision);
      }

      prefs.setString(themePrefKey, themePrefValue);
      emit(ThemeState(themeData: themeData, themeMode: themeMode, currentTheme: event, showPrevision: showPrevision));
    });

    _loadThemePref();
  }

  void _loadThemePref() async {
    final prefs = await SharedPreferences.getInstance();
    final themePref = prefs.getString(themePrefKey) ?? 'system';

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
    // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Marianne-Regular',
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: Colors.blue),
    // colorScheme: ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: Colors.deepOrangeAccent),
  );
}
