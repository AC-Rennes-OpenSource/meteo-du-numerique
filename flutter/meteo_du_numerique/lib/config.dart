import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  //  TODO mémo
  //  v3url : "https://www.toutatice.fr/strapi/services";
  //  v4url : "https://www.toutatice.fr/strapi/api/services?populate=*";
  static String get urlAttributes => dotenv.env['URL_ATTRIBUTES'] ?? '';

  static String get baseUrl {
    switch (dotenv.env['ENVIRONMENT']) {
      case 'development':
        return (kIsWeb
                ? dotenv.env['BASE_URL_WEB']
                : Platform.isAndroid
                    ? dotenv.env['BASE_URL_ANDROID']
                    : dotenv.env['BASE_URL_IOS']) ??
            'baseUrl non trouvée';
      case 'production':
        return dotenv.env['BASE_URL_PROD'] ?? '';
      case 'qualification':
        return dotenv.env['BASE_URL_QUALIF'] ?? '';
      default:
        return 'https://api.default.com';
    }
  }
}
