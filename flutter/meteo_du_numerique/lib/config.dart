import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static late FirebaseRemoteConfig remoteConfig;

  /// Initialise Remote Config
  static Future<void> init() async {
    remoteConfig = FirebaseRemoteConfig.instance;

    // Définir les valeurs par défaut
    await remoteConfig.setDefaults(<String, dynamic>{
      'show_previsions': true,
    });

    try {
      // Récupérer et activer les valeurs depuis Remote Config
      final bool fetched = await remoteConfig.fetchAndActivate();
      debugPrint(
          'Remote Config fetched: $fetched | show_previsions: ${remoteConfig.getBool('show_previsions')}');
    } catch (e) {
      debugPrint('Remote Config fetch failed: $e');
    }
  }

  /// Retourne l'attribut URL en fonction de la configuration actuelle
  static String get urlAttributes {

    final bool showPrevisions = remoteConfig.getBool('show_previsions');
    final String? url = showPrevisions
        ? dotenv.env['URL_ATTRIBUTES_V5']
        : dotenv.env['URL_ATTRIBUTES_PROD'];

    debugPrint(
        'Config.urlAttributes: show_previsions=$showPrevisions | URL=$url');

    return url ?? '';
  }

  /// Retourne la base URL en fonction de l'environnement
  static String get baseUrl {
    final String environment = dotenv.env['ENVIRONMENT'] ?? 'default';
    String? url;

    switch (environment) {
      case 'development':
        // url = kIsWeb
        //     ? dotenv.env['BASE_URL_WEB']
        //     :
        // Platform.isAndroid
        //     ? dotenv.env['BASE_URL_ANDROID']
        //     : dotenv.env['BASE_URL_IOS'];
      url = remoteConfig.getBool('show_previsions')? dotenv.env['BASE_URL_LOCAL']:dotenv.env['BASE_URL_PROD'];
      break;
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

    debugPrint('Config.baseUrl: environment=$environment | URL=$url');

    return url ?? 'baseUrl non trouvée';
  }
}