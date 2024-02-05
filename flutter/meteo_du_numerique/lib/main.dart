import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:meteo_du_numerique/bloc/items_bloc/items_bloc.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_bloc.dart';
import 'package:meteo_du_numerique/bloc/search_bar_bloc/search_bar_bloc.dart';
import 'package:meteo_du_numerique/bloc/tab_bloc/tab_bloc.dart';
import 'package:meteo_du_numerique/bloc/theme_bloc/theme_bloc.dart';
import 'package:meteo_du_numerique/theme_preferences.dart';
import 'package:meteo_du_numerique/bloc/theme_bloc/theme_state.dart';
import 'package:meteo_du_numerique/services/api_service.dart';
import 'package:meteo_du_numerique/ui/pages/items_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('fr_FR', null);

  final themePreferences = ThemePreferences();
  final themeMode = await themePreferences.getThemeMode();

  runApp(
    MyApp(
      themeModePreference: themeMode,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeModePreference themeModePreference;

  const MyApp({super.key, required this.themeModePreference});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ItemsBloc>(
          create: (context) => ItemsBloc(apiService: ApiService(), useMockData: true),
        ),
        BlocProvider<TabBloc>(
          create: (context) => TabBloc(),
        ),
        BlocProvider<PrevisionsBloc>(
          create: (context) => PrevisionsBloc(apiService: ApiService(), useMockData: true),
        ),
        BlocProvider<SearchBarBloc>(
          create: (context) => SearchBarBloc(),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            locale: const Locale.fromSubtags(languageCode: "fr", countryCode: "FR"),
            title: 'Météo du numérique',
            theme: themeState.themeData,
            themeMode: getThemeMode(themeModePreference),
            home: const ItemsPage(),
          );
        },
      ),
    );
  }
}


