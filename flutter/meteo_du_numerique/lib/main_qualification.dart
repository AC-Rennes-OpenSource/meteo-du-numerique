import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:meteo_du_numerique/bloc/items_bloc/services_num_bloc.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_bloc.dart';
import 'package:meteo_du_numerique/bloc/search_bar_bloc/search_bar_bloc.dart';
import 'package:meteo_du_numerique/bloc/theme_bloc/theme_bloc.dart';
import 'package:meteo_du_numerique/bloc/theme_bloc/theme_state.dart';
import 'package:meteo_du_numerique/services/api_service.dart';
import 'package:meteo_du_numerique/ui/pages/home_page.dart';
import 'package:meteo_du_numerique/ui/theme_preferences.dart';
import 'package:meteo_du_numerique/web/home_page_web.dart';

import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _initLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_notification');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await localNotificationsPlugin.initialize(initializationSettings);
}

Future<void> main() async {
  await dotenv.load(fileName: ".env.qualification"); // Charge les variables d'environnement
  String apiKey = dotenv.env['API_KEY'] ?? "Clé API non trouvée";
  print("----------------------$apiKey");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _initLocalNotifications();
  initializeDateFormatting('fr_FR', null);

  final themePreferences = ThemePreferences();
  final themeMode = await themePreferences.getThemeMode();

  runApp(MyApp(themeModePreference: themeMode));
}

class MyApp extends StatefulWidget {
  final ThemeModePreference themeModePreference;

  const MyApp({super.key, required this.themeModePreference});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _requestPermissions();
      _configureFirebaseListeners();
    }
  }

  void _requestPermissions() {
    FirebaseMessaging.instance
        .requestPermission(
      alert: true,
      badge: true,
      sound: true,
    )
        .then((settings) {
      FirebaseMessaging.instance.subscribeToTopic('notifications_meteo');
      print("User granted permission: ${settings.authorizationStatus}");
    });
  }

  void _configureFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? ios = message.notification?.apple;

      if (notification != null) {
        NotificationDetails platformChannelSpecifics;

        if (android != null) {
          platformChannelSpecifics = const NotificationDetails(
            android: AndroidNotificationDetails(
              'your channel id',
              'your channel name',
              channelDescription: 'your channel description',
              importance: Importance.max,
              priority: Priority.high,
            ),
          );
        } else if (ios != null && Platform.isIOS) {
          platformChannelSpecifics = const NotificationDetails(
              iOS: DarwinNotificationDetails(
            sound: 'default',
          ));
        } else {
          return;
        }

        localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          platformChannelSpecifics,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }

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
            locale: const Locale.fromSubtags(languageCode: "fr", countryCode: "FR"),
            title: 'Météo du numérique',
            theme: ThemeBloc.lightTheme,
            darkTheme: ThemeBloc.darkTheme,
            themeMode: themeState.themeMode,
            home: kIsWeb ? const HomePageWeb() : const HomePage(),
          );
        },
      ),
    );
  }
}
