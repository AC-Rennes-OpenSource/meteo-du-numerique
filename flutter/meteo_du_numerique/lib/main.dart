import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'core/config/flavor_config.dart';
import 'core/di/service_locator.dart';
import 'firebase_options.dart';
import 'presentation/app/app.dart';

void main() async {

  FlavorConfig.init(const String.fromEnvironment('FLAVOR'));

  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize timezone data (needed for scheduled notifications)
  tz.initializeTimeZones();

  // Initialize date formatting
  await initializeDateFormatting('fr_FR');

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize dependency injection and services
  await setupServiceLocator();

  // Run the app
  runApp(const App());
}