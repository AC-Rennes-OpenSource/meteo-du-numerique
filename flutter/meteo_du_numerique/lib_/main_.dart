import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:meteo_du_numerique/bloc/items_bloc/services_num_bloc.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_bloc_2.dart';
import 'package:meteo_du_numerique/bloc/search_bar_bloc/search_bar_bloc.dart';
import 'package:meteo_du_numerique/bloc/theme_bloc/theme_bloc.dart';
import 'package:meteo_du_numerique/config/firebase_config.dart';
import 'package:meteo_du_numerique/config/theme_preferences.dart';
import 'package:meteo_du_numerique/cubit/app_cubit.dart';
import 'package:meteo_du_numerique/services/api_service.dart';
import 'package:meteo_du_numerique/services/notification_service.dart';
import 'package:meteo_du_numerique/ui/pages/home_page.dart';

import 'bloc/theme_bloc/theme_state.dart';
import 'config.dart';
import 'cubit/previsions_cubit.dart';
import 'cubit/services_numeriques_cubit.dart';
import 'services/mock-api-service.dart';
import 'ui/pages/home-page-test.dart';
import 'ui/pages/home_page2_cubit.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseConfig.initialize();
  await NotificationService.initialize();
  await initializeDateFormatting('fr_FR', null);

  final themePreferences = ThemePreferences();
  final themeMode = await themePreferences.getThemeMode();

  final remoteConfig = await FirebaseConfig.initRemoteConfig();

  await Config.init();

  runApp(MyApp(themeModePreference: themeMode, remoteConfig: remoteConfig));
}

class MyApp extends StatelessWidget {
  final ThemeModePreference themeModePreference;
  final FirebaseRemoteConfig remoteConfig;

  const MyApp({super.key, required this.themeModePreference, required this.remoteConfig});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ServicesNumeriquesCubit>(
          create: (context) => ServicesNumeriquesCubit(MockApiService())..loadServices(),
        ),
        BlocProvider<PrevisionsCubit>(
          create: (context) => PrevisionsCubit(MockApiService())..loadPrevisions(),
        ),


        BlocProvider(create: (_) => ServicesNumBloc(apiService: ApiService(), useMockData: true)),
        BlocProvider(create: (_) => AppCubit()),
        BlocProvider(create: (_) => PrevisionsBloc(apiService: ApiService(), useMockData: true)),
        BlocProvider(create: (_) => SearchBarBloc()),
        BlocProvider(create: (_) => ThemeBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: const Locale.fromSubtags(languageCode: "fr", countryCode: "FR"),
            title: 'Météo du numérique',
            theme: ThemeBloc.lightTheme,
            darkTheme: ThemeBloc.darkTheme,
            themeMode: themeState.themeMode,
            home: (remoteConfig.getBool('show_previsions') ? HomePage() : HomePage2()),
          );
        },
      ),
    );
  }
}
