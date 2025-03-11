import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:meteo_du_numerique/bloc/items_bloc/services_num_bloc.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_bloc_2.dart';
import 'package:meteo_du_numerique/bloc/search_bar_bloc/search_bar_bloc.dart';
import 'package:meteo_du_numerique/bloc/theme_bloc/theme_bloc.dart';
import 'package:meteo_du_numerique/config/theme_preferences.dart';
import 'package:meteo_du_numerique/cubit/app_cubit.dart';
import 'package:meteo_du_numerique/services/api_service.dart';
import 'package:meteo_du_numerique/services/data_cubit.dart';
import 'package:meteo_du_numerique/services/preferences_cubit.dart';
import 'package:meteo_du_numerique/services/service_locator.dart';

import 'bloc/theme_bloc/theme_state.dart';
import 'config.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Initialisation des services
  await _initializeServices();

  // Initialisation des préférences
  final themePreferences = ThemePreferences();
  final themeMode = await themePreferences.getThemeMode();

  runApp(MyApp(themeModePreference: themeMode));
}

Future<void> _initLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_notification');

  // Configuration pour iOS
  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await localNotificationsPlugin.initialize(
    initializationSettings,
  );
}

Future<void> _initializeServices() async {
  // Initialisation de Firebase
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  // Initialisation des autres services
  await Config.init();
  await initializeDateFormatting('fr_FR', null);

  await _initLocalNotifications();
}

class MyApp extends StatelessWidget {
  final ThemeModePreference themeModePreference;

  // final FirebaseRemoteConfig remoteConfig;

  const MyApp({super.key, required this.themeModePreference
      // , required this.remoteConfig
      });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
            // home: (remoteConfig.getBool('show_previsions') ? HomePage() : HomePage2()),
            home: HomePage_cubit(),
          );
        },
      ),
    );
  }
}

class HomePage_cubit extends StatelessWidget {
  const HomePage_cubit({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => locator<DataCubit>()
              ..loadForecasts()
              ..loadNews()),
        BlocProvider(create: (_) => locator<PreferencesCubit>()),
      ],
      child: BlocBuilder<PreferencesCubit, PreferencesState>(
        builder: (context, preferencesState) {
          return MaterialApp(
            themeMode: preferencesState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.blueGrey),
            theme: ThemeData.light().copyWith(primaryColor: Colors.lightBlue),
            home: DefaultTabController(
              length: 2,
              child: Scaffold(
                  appBar: AppBar(
                    title: Text(preferencesState.isDarkMode ? "Mode Sombre" : "Accueil"),
                    bottom: TabBar(tabs: [Tab(text: "Prévisions"), Tab(text: "Actualités")]),
                    actions: [
                      IconButton(
                        icon: Icon(preferencesState.isDarkMode ? Icons.dark_mode : Icons.light_mode),
                        onPressed: () => context.read<PreferencesCubit>().toggleDarkMode(),
                      ),
                    ],
                  ),
                  body: TabBarView(children: [ForecastList(), NewsList()])),
            ),
          );
        },
      ),
    );
  }
}

class ForecastList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DataCubit>();

    return CustomScrollView(
      slivers: [
        // SliverAppBar pour les filtres et le tri
        SliverAppBar(
          pinned: true,
          floating: true,
          expandedHeight: 150.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Champ de recherche
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Rechercher",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (query) => cubit.updateSearchQuery(query),
                  ),
                  SizedBox(height: 8),
                  // Boutons de filtre et de tri
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Bouton de filtre par catégorie
                      DropdownButton<String>(
                        value: cubit.state.filterCategory,
                        hint: Text("Filtrer par catégorie"),
                        items: [
                          DropdownMenuItem(value: null, child: Text("Toutes")),
                          DropdownMenuItem(value: "Pédagogie", child: Text("Pédagogie")),
                          DropdownMenuItem(value: "Finance", child: Text("Finance")),
                        ],
                        onChanged: (value) => cubit.updateFilterCategory(value),
                      ),
                      // Bouton de tri
                      DropdownButton<SortType>(
                        value: cubit.state.sortType,
                        items: [
                          DropdownMenuItem(value: SortType.alphabetic, child: Text("Alphabétique")),
                          DropdownMenuItem(value: SortType.date, child: Text("Par date")),
                        ],
                        onChanged: (value) => cubit.updateSortType(value!),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // Liste des prévisions
        BlocBuilder<DataCubit, DataState>(
          builder: (context, state) {
            if (state.isLoading) {
              return SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state.error != null) {
              return SliverFillRemaining(
                child: Center(child: Text('Erreur : ${state.error}')),
              );
            }

            final filteredForecasts = cubit.getFilteredForecasts();

            if (filteredForecasts.isEmpty) {
              return SliverFillRemaining(
                child: Center(child: Text('Aucune prévision disponible.')),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final forecast = filteredForecasts[index];
                  return ListTile(
                    title: Text(forecast.libelle),
                    subtitle: Text(forecast.description),
                  );
                },
                childCount: filteredForecasts.length,
              ),
            );
          },
        ),
      ],
    );
  }
}

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DataCubit>();

    return CustomScrollView(
      slivers: [
        // SliverAppBar pour les filtres et le tri
        SliverAppBar(
          pinned: true,
          floating: true,
          expandedHeight: 150.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Champ de recherche
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Rechercher",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (query) => cubit.updateSearchQuery(query),
                  ),
                  SizedBox(height: 8),
                  // Boutons de filtre et de tri
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Bouton de filtre par catégorie
                      DropdownButton<String>(
                        value: cubit.state.filterCategory,
                        hint: Text("Filtrer par catégorie"),
                        items: [
                          DropdownMenuItem(value: null, child: Text("Toutes")),
                          DropdownMenuItem(value: "Pédagogie", child: Text("Pédagogie")),
                          DropdownMenuItem(value: "Finance", child: Text("Finance")),
                        ],
                        onChanged: (value) => cubit.updateFilterCategory(value),
                      ),
                      // Bouton de tri
                      DropdownButton<SortType>(
                        value: cubit.state.sortType,
                        items: [
                          DropdownMenuItem(value: SortType.alphabetic, child: Text("Alphabétique")),
                          DropdownMenuItem(value: SortType.date, child: Text("Par date")),
                        ],
                        onChanged: (value) => cubit.updateSortType(value!),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // Liste des actualités
        BlocBuilder<DataCubit, DataState>(
          builder: (context, state) {
            if (state.isLoading) {
              return SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state.error != null) {
              return SliverFillRemaining(
                child: Center(child: Text('Erreur : ${state.error}')),
              );
            }

            final filteredNews = cubit.getFilteredNews();

            if (filteredNews.isEmpty) {
              return SliverFillRemaining(
                child: Center(child: Text('Aucune actualité disponible.')),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final newsItem = filteredNews[index];
                  return ListTile(
                    title: Text(newsItem.libelle),
                    subtitle: Text(newsItem.description),
                  );
                },
                childCount: filteredNews.length,
              ),
            );
          },
        ),
      ],
    );
  }
}
