import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'core/config/firebase_config.dart';
import 'core/config/flavor_config.dart';
import 'core/di/service_locator.dart';
import 'firebase_options.dart';
import 'presentation/app/app.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // Initialize flavor configuration
  FlavorConfig.init(const String.fromEnvironment('FLAVOR'));

  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Firebase first
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize dependency injection
  await setupServiceLocator();

  // Initialize remaining services
  await _initializeServices();

  // Run the app
  runApp(const App());
}

Future<void> _initLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_notification');

  // Configuration for iOS
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
  // Initialize timezone data (for scheduled notifications)
  tz.initializeTimeZones();

  // Initialize date formatting
  await initializeDateFormatting('fr_FR', null);

  // Initialize local notifications
  await _initLocalNotifications();

  // Initialize Firebase Remote Config
  await FirebaseConfig.initRemoteConfig();
}
