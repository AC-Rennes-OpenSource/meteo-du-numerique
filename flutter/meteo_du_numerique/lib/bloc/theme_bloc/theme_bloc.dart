import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/bloc/theme_bloc/theme_event.dart';
import 'package:meteo_du_numerique/bloc/theme_bloc/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/theme_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final String themePrefKey = 'selectedTheme';
  final String prevPrefKey = 'selectedPrev';



  ThemeBloc() : super(ThemeState(
      showPrevision: false,
      themeData: lightTheme, themeMode: ThemeMode.system, currentTheme: ThemeEvent.toggleSystem)) {
    on<ThemeEvent>((event, emit) async {

      final prefs = await SharedPreferences.getInstance();
      ThemeData themeData = state.themeData;
      ThemeMode themeMode = state.themeMode;
      String themePrefValue = prefs.getString(themePrefKey) ?? 'system';
      bool showPrevision = prefs.getBool(prevPrefKey) ?? false;

      if (event == ThemeEvent.showPrevision) {
        showPrevision = !state.showPrevision;
        final themePreferences = ThemePreferences();
        themePreferences.setShowBetaFeatures(showPrevision);
        prefs.setBool(prevPrefKey, showPrevision);
        print("prefs.getBool(prevPrefKey) : "+prefs.getBool(prevPrefKey).toString());
        emit(ThemeState(themeData: state.themeData, themeMode: state.themeMode, currentTheme: state.currentTheme,
            showPrevision: showPrevision
        ));
      } else if (event == ThemeEvent.toggleLight) {
        themeData = lightTheme;
        themeMode = ThemeMode.light;
        themePrefValue = 'light';
        prefs.setString(themePrefKey, themePrefValue);
        emit(ThemeState(themeData: themeData, themeMode: themeMode, currentTheme: event,
            showPrevision: state.showPrevision
        ));
      } else if (event == ThemeEvent.toggleDark) {
        themeData = darkTheme;
        themeMode = ThemeMode.dark;
        themePrefValue = 'dark';
        prefs.setString(themePrefKey, themePrefValue);
        emit(ThemeState(themeData: themeData, themeMode: themeMode, currentTheme: event,
            showPrevision: state.showPrevision
        ));
      } else if (event == ThemeEvent.toggleSystem) {
        final brightness = WidgetsBinding.instance.window.platformBrightness;
        themeData = brightness == Brightness.dark ? darkTheme : lightTheme;
        themeMode = ThemeMode.system;
        themePrefValue = 'system';
        prefs.setString(themePrefKey, themePrefValue);
        emit(ThemeState(themeData: themeData, themeMode: themeMode, currentTheme: event,
            showPrevision: state.showPrevision
        ));
      }
      prefs.getBool(prevPrefKey);
    });

    _loadThemePref();
  }

  void _loadThemePref() async {
    final prefs = await SharedPreferences.getInstance();
    final themePref = prefs.getString(themePrefKey) ?? 'system';

    final themePreferences = ThemePreferences();
    final showBetaFeatures = await themePreferences.getShowBetaFeatures();
    if (showBetaFeatures) {
      add(ThemeEvent.showPrevision);
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
    // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Marianne-Regular',
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: Colors.blue),
    // colorScheme: ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: Colors.deepOrangeAccent),
  );
}
