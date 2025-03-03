import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static late FirebaseRemoteConfig remoteConfig;

  /// Initialize Remote Config
  static Future<void> init() async {
    remoteConfig = FirebaseRemoteConfig.instance;

    // Set default values
    await remoteConfig.setDefaults(<String, dynamic>{
      'show_forecasts': false,
    });

    try {
      // Fetch and activate values from Remote Config
      final bool fetched = await remoteConfig.fetchAndActivate();
      debugPrint(
          'Remote Config fetched: $fetched | show_forecasts: ${remoteConfig.getBool('show_forecasts')}');
    } catch (e) {
      debugPrint('Remote Config fetch failed: $e');
    }
  }

  /// Returns the URL attribute based on current configuration
  static String get urlAttributes {
    final bool showForecasts = remoteConfig.getBool('show_forecasts');
    final String? url = showForecasts
        ? dotenv.env['URL_ATTRIBUTES_V5']
        : dotenv.env['URL_ATTRIBUTES_PROD'];

    debugPrint(
        'AppConfig.urlAttributes: show_forecasts=$showForecasts | URL=$url');

    return url ?? '';
  }

  /// Returns the base URL based on environment
  static String get baseUrl {
    final String environment = dotenv.env['ENVIRONMENT'] ?? 'default';
    String? url;

    switch (environment) {
      case 'development':
        url = remoteConfig.getBool('show_forecasts')
            ? dotenv.env['BASE_URL_LOCAL']
            : dotenv.env['BASE_URL_PROD'];
        break;
      case 'production':
        url = dotenv.env['BASE_URL_PROD'];
        break;
      case 'qualification':
        url = dotenv.env['BASE_URL_QUALIF'];
        break;
      default:
        url = 'https://api.default.com';
    }

    debugPrint('AppConfig.baseUrl: environment=$environment | URL=$url');

    return url ?? 'Base URL not found';
  }
}