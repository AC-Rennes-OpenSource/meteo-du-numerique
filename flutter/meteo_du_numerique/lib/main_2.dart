// import 'dart:io';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart'; // Ajout de la bibliothèque Remote Config
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:meteo_du_numerique/bloc/items_bloc/services_num_bloc.dart';
// import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_bloc.dart';
// import 'package:meteo_du_numerique/bloc/search_bar_bloc/search_bar_bloc.dart';
// import 'package:meteo_du_numerique/bloc/theme_bloc/theme_bloc.dart';
// import 'package:meteo_du_numerique/bloc/theme_bloc/theme_state.dart';
// import 'package:meteo_du_numerique/firebase_options.dart';
// import 'package:meteo_du_numerique/services/api_service.dart';
// import 'package:meteo_du_numerique/ui/pages/home_page2.dart';
// import 'package:meteo_du_numerique/ui/theme_preferences.dart';
// import 'package:meteo_du_numerique/web-ui/home_page_web.dart';
//
// final FlutterLocalNotificationsPlugin localNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
// }
//
// Future<void> main() async {
//   await dotenv.load(fileName: ".env"); // Charge les variables d'environnement
//   WidgetsFlutterBinding.ensureInitialized();
//
//   if (Firebase.apps.isEmpty) {
//     await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform);
//
//     try {
//       FirebaseApp app = Firebase.app();
//       print('--- Firebase Configuration ---');
//       print('App Name: ${app.name}');
//       print('API Key: ${app.options.apiKey ?? "N/A"}');
//       print('Project ID: ${app.options.projectId ?? "N/A"}');
//       print('App ID: ${app.options.appId ?? "N/A"}');
//       print('Messaging Sender ID: ${app.options.messagingSenderId ?? "N/A"}');
//       print('Database URL: ${app.options.databaseURL ?? "N/A"}');
//       print('Storage Bucket: ${app.options.storageBucket ?? "N/A"}');
//       print('--------------------------------');
//     } catch (e) {
//       print('Erreur lors de la récupération des détails Firebase: $e');
//     }
//   }
//
//   await _initRemoteConfig();
//
//   // await _initLocalNotifications();
//   initializeDateFormatting('fr_FR', null);
//
//   final themePreferences = ThemePreferences();
//   final themeMode = await themePreferences.getThemeMode();
//
//   // Get APNS token for iOS
//   // String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
//   // print('APNS Token: $apnsToken');
//
//   runApp(MyApp(themeModePreference: themeMode));
// }
//
// Future<void> _initRemoteConfig() async {
//   final remoteConfig = FirebaseRemoteConfig.instance;
//   await remoteConfig.setConfigSettings(RemoteConfigSettings(
//     fetchTimeout: const Duration(minutes: 1),
//     minimumFetchInterval: const Duration(seconds: 10),
//   ));
//   await remoteConfig.setDefaults({
//     'show_feature': false,
//     'strapi_5': false,
//   });
//   await remoteConfig.fetchAndActivate().then((updated) {
//     print(remoteConfig.getBool('show_previsions'));
//     print(remoteConfig.getBool('strapi_5'));
//     print("remote config updated? : "+updated.toString());
//   });
// }
//
// class MyApp extends StatefulWidget {
//   final ThemeModePreference themeModePreference;
//
//   const MyApp({super.key, required this.themeModePreference});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     if (!kIsWeb) {
//       _requestPermissions();
//       _configureFirebaseListeners();
//     }
//   }
//
//   void _requestPermissions() {
//     FirebaseMessaging.instance
//         .requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     )
//         .then((settings) {
//       // FirebaseMessaging.instance.subscribeToTopic('notifications_meteo');
//       FirebaseMessaging.instance
//           .subscribeToTopic(dotenv.env['FCM_TOPIC_NAME']!);
//       print("User granted permission: ${settings.authorizationStatus}");
//     });
//
//     FirebaseMessaging.instance.getToken().then((token) {
//       print('Jeton FCM : ${token!}');
//     });
//   }
//
//   void _configureFirebaseListeners() {
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Message received: ${message.notification}');
//
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       AppleNotification? ios = message.notification?.apple;
//
//       if (notification != null) {
//         NotificationDetails platformChannelSpecifics;
//
//         if (android != null) {
//           platformChannelSpecifics = const NotificationDetails(
//             android: AndroidNotificationDetails(
//               'meteo-updated',
//               'Mise à jour de la météo du numérique',
//               channelDescription: '',
//               importance: Importance.max,
//               priority: Priority.high,
//             ),
//           );
//         } else if (ios != null && Platform.isIOS) {
//           platformChannelSpecifics = const NotificationDetails(
//               iOS: DarwinNotificationDetails(
//             sound: 'default',
//           ));
//         } else {
//           return;
//         }
//
//         localNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           platformChannelSpecifics,
//         );
//       }
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<ServicesNumBloc>(
//           create: (_) =>
//               ServicesNumBloc(apiService: ApiService(), useMockData: true),
//         ),
//         BlocProvider<PrevisionsBloc>(
//           create: (_) =>
//               PrevisionsBloc(apiService: ApiService(), useMockData: true),
//         ),
//         BlocProvider<SearchBarBloc>(
//           create: (_) => SearchBarBloc(),
//         ),
//         BlocProvider<ThemeBloc>(
//           create: (_) => ThemeBloc(),
//         ),
//       ],
//       child: BlocBuilder<ThemeBloc, ThemeState>(
//         builder: (context, themeState) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             locale:
//                 const Locale.fromSubtags(languageCode: "fr", countryCode: "FR"),
//             title: 'Météo du numérique',
//             theme: ThemeBloc.lightTheme,
//             darkTheme: ThemeBloc.darkTheme,
//             themeMode: themeState.themeMode,
//             home: kIsWeb ? const HomePageWeb() : HomePage2(),
//           );
//         },
//       ),
//     );
//   }
// }
