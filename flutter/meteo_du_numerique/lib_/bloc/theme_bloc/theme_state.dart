import 'package:flutter/material.dart';
import 'package:meteo_du_numerique/bloc/theme_bloc/theme_event.dart';

class ThemeState {
  final ThemeData themeData;
  final ThemeMode themeMode;
  final ThemeEvent currentTheme;

  ThemeState({required this.themeData, required this.themeMode, required this.currentTheme});

  bool get isDarkMode => themeData.brightness == Brightness.dark;
}
