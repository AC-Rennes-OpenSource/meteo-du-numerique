import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/bloc/theme_bloc/theme_bloc.dart';
import 'package:meteo_du_numerique/ui/pages/home_page2.dart';

import '../bloc/items_bloc/services_num_bloc.dart';
import '../bloc/previsions_bloc/previsions_bloc.dart';
import '../bloc/search_bar_bloc/search_bar_bloc.dart';
import '../bloc/theme_bloc/theme_state.dart';
import '../services/api_service.dart';

class MeteoApp extends StatelessWidget {
  const MeteoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ServicesNumBloc>(
          create: (_) => ServicesNumBloc(apiService: ApiService(), useMockData: true),
        ),
        BlocProvider<PrevisionsBloc>(
          create: (_) => PrevisionsBloc(apiService: ApiService(), useMockData: true),
        ),
        BlocProvider<SearchBarBloc>(
          create: (_) => SearchBarBloc(),
        ),
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Météo du Numérique',
            themeMode: themeState.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: HomePage2(),
          );
        },
      ),
    );
  }
}
