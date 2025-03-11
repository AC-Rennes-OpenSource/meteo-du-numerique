import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:meteo_du_numerique/bloc/search_bar_bloc/search_bar_bloc.dart';
import 'package:meteo_du_numerique/bloc/theme_bloc/theme_bloc.dart';
import 'package:meteo_du_numerique/bloc/theme_bloc/theme_state.dart';
import 'package:meteo_du_numerique/config/theme_preferences.dart';
import 'package:meteo_du_numerique/firebase_options.dart';
import 'package:meteo_du_numerique/services/api_service.dart';
import 'package:meteo_du_numerique/ui/pages/home_page.dart';

import 'bloc/services_num_bloc/services_num_bloc.dart';
import 'config.dart';
import 'cubit/app_cubit.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
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

  late bool showPrevisions; // Changé de 'bool' à 'late bool' pour éviter l'erreur de non-initialisation

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        // name: 'meteo-du-numerique-acrennes',
        options: DefaultFirebaseOptions.currentPlatform);

    try {
      FirebaseApp app = Firebase.app();
      debugPrint('--- Firebase Configuration ---');
      debugPrint('App Name: ${app.name}');
      debugPrint('API Key: ${app.options.apiKey ?? "N/A"}');
      debugPrint('Project ID: ${app.options.projectId ?? "N/A"}');
      debugPrint('App ID: ${app.options.appId ?? "N/A"}');
      debugPrint('Messaging Sender ID: ${app.options.messagingSenderId ?? "N/A"}');
      debugPrint('Database URL: ${app.options.databaseURL ?? "N/A"}');
      debugPrint('Storage Bucket: ${app.options.storageBucket ?? "N/A"}');
      debugPrint('--------------------------------');
    } catch (e) {
      debugPrint('Erreur lors de la récupération des détails Firebase: $e');
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
  // debugPrint('APNS Token: $apnsToken');

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
    debugPrint("show_previsions : ${remoteConfig.getBool('show_previsions')}");
    debugPrint("strapi_5 : ${remoteConfig.getBool('strapi_5')}");
    debugPrint("remote config updated? : $updated");
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
    _requestPermissions();
    _configureFirebaseListeners();
    _loadRemoteConfig();
  }

  Future<void> _loadRemoteConfig() async {
    try {
      // Ajout d'un bloc try-catch pour une meilleure gestion des erreurs
      final remoteConfig = await _initRemoteConfig();
      setState(() {
        // showPrevisions = remoteConfig.getBool('show_previsions');
        configurationFromFirebase = remoteConfig;
        isConfigLoaded = true;
      });
    } catch (e) {
      debugPrint('Erreur lors du chargement de la configuration: $e');
      setState(() {
        isConfigLoaded = true; // On considère quand même que c'est chargé pour ne pas bloquer l'app
        showPrevisions = false; // Valeur par défaut en cas d'erreur
      });
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
      // FirebaseMessaging.instance.subscribeToTopic('notifications_meteo');
      FirebaseMessaging.instance.subscribeToTopic(dotenv.env['FCM_TOPIC_NAME']!);
      debugPrint("User granted permission: ${settings.authorizationStatus}");
    });

    // FirebaseMessaging.instance.getToken().then((token) {
    //   debugPrint('Jeton FCM : ${token!}');
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
      debugPrint('A new onMessageOpenedApp event was published!');
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
        BlocProvider<SearchBarBloc>(create: (_) => SearchBarBloc()),
        BlocProvider<AppCubit>(create: (_) => AppCubit()),
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
            home: HomePage(),
          );
        },
      ),
    );
  }
}
