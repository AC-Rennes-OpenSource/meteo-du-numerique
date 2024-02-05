import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/bloc/theme_bloc/theme_event.dart';
import 'package:meteo_du_numerique/bloc/theme_bloc/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final String themePrefKey = 'selectedTheme';

  ThemeBloc() : super(ThemeState(themeData: lightTheme, currentTheme: ThemeEvent.toggleSystem)) {
    on<ThemeEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      ThemeData themeData;
      String themePrefValue;

      switch (event) {
        case ThemeEvent.toggleLight:
          themeData = lightTheme;
          themePrefValue = 'light';
          break;
        case ThemeEvent.toggleDark:
          themeData = darkTheme;
          themePrefValue = 'dark';
          break;
        case ThemeEvent.toggleSystem:
          final brightness = WidgetsBinding.instance.window.platformBrightness;
          themeData = brightness == Brightness.dark ? darkTheme : lightTheme;
          themePrefValue = 'system';
          break;
      }

      prefs.setString(themePrefKey, themePrefValue);
      emit(ThemeState(themeData: themeData, currentTheme: event));
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
}

final ThemeData lightTheme = ThemeData(
  fontFamily: 'Marianne-Regular',
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
);

final ThemeData darkTheme = ThemeData(
  fontFamily: 'Marianne-Regular',
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: Colors.blue),
);
