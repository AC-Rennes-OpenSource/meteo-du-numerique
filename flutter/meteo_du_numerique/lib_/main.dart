import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
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
import 'package:meteo_du_numerique/config/theme_preferences.dart';
import 'package:meteo_du_numerique/firebase_options.dart';
import 'package:meteo_du_numerique/services/api_service.dart';
import 'package:meteo_du_numerique/ui/pages/home_page.dart';
import 'package:meteo_du_numerique/ui/pages/home_page2.dart';
import 'package:meteo_du_numerique/web-ui/home_page_web.dart';

import 'config.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
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

Future<void> main() async {
  await dotenv.load(fileName: ".env"); // Charge les variables d'environnement
  WidgetsFlutterBinding.ensureInitialized();

  bool showPrevisions;

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        // name: 'meteo-du-numerique-acrennes',
        options: DefaultFirebaseOptions.currentPlatform);

    try {
      FirebaseApp app = Firebase.app();
      print('--- Firebase Configuration ---');
      print('App Name: ${app.name}');
      print('API Key: ${app.options.apiKey ?? "N/A"}');
      print('Project ID: ${app.options.projectId ?? "N/A"}');
      print('App ID: ${app.options.appId ?? "N/A"}');
      print('Messaging Sender ID: ${app.options.messagingSenderId ?? "N/A"}');
      print('Database URL: ${app.options.databaseURL ?? "N/A"}');
      print('Storage Bucket: ${app.options.storageBucket ?? "N/A"}');
      print('--------------------------------');
    } catch (e) {
      print('Erreur lors de la récupération des détails Firebase: $e');
    }
  }

  await _initRemoteConfig().then((remoteConfig) {
    showPrevisions = remoteConfig.getBool("show_previsions");
  });

  // await _initLocalNotifications();
  initializeDateFormatting('fr_FR', null);

  final themePreferences = ThemePreferences();
  final themeMode = await themePreferences.getThemeMode();

  // Get APNS token for iOS
  // String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  // print('APNS Token: $apnsToken');

  await Config.init(); // Initialiser Remote Config

  runApp(MyApp(themeModePreference: themeMode));
}

Future<FirebaseRemoteConfig> _initRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(seconds: 10),
  ));
  await remoteConfig.setDefaults({
    'show_previsions': false,
    'strapi_5': false,
  });
  await remoteConfig.fetchAndActivate().then((updated) {
    print("show_previsions : ${remoteConfig.getBool('show_previsions')}");
    print("strapi_5 : ${remoteConfig.getBool('strapi_5')}");
    print("remote config updated? : $updated");
    return remoteConfig;
  });
  return remoteConfig;
}

class MyApp extends StatefulWidget {
  final ThemeModePreference themeModePreference;

  const MyApp({super.key, required this.themeModePreference});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isConfigLoaded = false;
  bool showPrevisions = false;
  late FirebaseRemoteConfig configurationFromFirebase;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _requestPermissions();
      _configureFirebaseListeners();
    }

    // Charger la configuration à distance
    _loadRemoteConfig();
  }

  Future<void> _loadRemoteConfig() async {
    final remoteConfig = await _initRemoteConfig();
    setState(() {
      showPrevisions = remoteConfig.getBool('show_previsions');
      configurationFromFirebase = remoteConfig;
      isConfigLoaded = true; // Indique que la configuration est prête
    });
  }

  void _requestPermissions() {
    FirebaseMessaging.instance
        .requestPermission(
      alert: true,
      badge: true,
      sound: true,
    )
        .then((settings) {
      // FirebaseMessaging.instance.subscribeToTopic('notifications_meteo');
      FirebaseMessaging.instance.subscribeToTopic(dotenv.env['FCM_TOPIC_NAME']!);
      print("User granted permission: ${settings.authorizationStatus}");
    });

    // FirebaseMessaging.instance.getToken().then((token) {
    //   print('Jeton FCM : ${token!}');
    // });
  }

  void _configureFirebaseListeners() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
    // Afficher un écran de chargement pendant la récupération de la configuration
    if (!isConfigLoaded) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider<ServicesNumBloc>(
          create: (_) => ServicesNumBloc(apiService: ApiService(), useMockData: true),
        ),
        BlocProvider<PrevisionsBloc>(
          create: (_) => PrevisionsBloc(apiService: ApiService(), useMockData: true),
        ),
        BlocProvider<SearchBarBloc>(create: (_) => SearchBarBloc()),
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc(),
        ),
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
            home: kIsWeb
                ? const HomePageWeb()
                : (showPrevisions
                    //TODO
                    ? HomePage()
                    : HomePage2()),
          );
        },
      ),
    );
  }
}
