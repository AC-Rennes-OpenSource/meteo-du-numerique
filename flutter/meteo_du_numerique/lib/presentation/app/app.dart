import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:meteo_du_numerique/domain/blocs/theme/theme_bloc.dart';
import 'package:meteo_du_numerique/domain/blocs/theme/theme_state.dart';

import '../../domain/blocs/digital_services/digital_services_bloc.dart';
import '../../domain/blocs/forecasts/forecasts_bloc.dart';
import '../../domain/blocs/search/search_bloc.dart';
import '../../domain/cubits/app_cubit.dart';
import '../features/home/pages/home_page.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late ThemeBloc _themeBloc;
  
  @override
  void initState() {
    super.initState();
    _themeBloc = ThemeBloc();
    _initRemoteConfig();
  }
  
  @override
  void dispose() {
    _themeBloc.close();
    super.dispose();
  }

  Future<void> _initRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    
    await remoteConfig.fetchAndActivate();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _themeBloc),
        BlocProvider(create: (_) => SearchBloc()),
        BlocProvider(create: (_) => DigitalServicesBloc()),
        BlocProvider(create: (_) => ForecastsBloc()),
        BlocProvider(create: (_) => AppCubit()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Météo du Numérique',
            theme: ThemeBloc.lightTheme,
            darkTheme: ThemeBloc.darkTheme,
            themeMode: state.themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}