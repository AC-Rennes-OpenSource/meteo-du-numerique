import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:meteo_du_numerique/firebase_options.dart';

class FirebaseConfig {
  static Future<void> initialize() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform
      );
      _printFirebaseDetails();
    }
  }

  static Future<FirebaseRemoteConfig> initRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
    await remoteConfig.setDefaults({
      'show_forecasts': true,
      'strapi_5': false,
    });
    await remoteConfig.fetchAndActivate();
    debugPrint("show_forecasts : ${remoteConfig.getBool('show_forecasts')}");
    debugPrint("strapi_5 : ${remoteConfig.getBool('strapi_5')}");
    return remoteConfig;
  }

  static void _printFirebaseDetails() {
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
      debugPrint('Error retrieving Firebase details: $e');
    }
  }
}