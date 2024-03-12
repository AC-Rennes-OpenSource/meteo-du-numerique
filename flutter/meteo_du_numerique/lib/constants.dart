// lib/constants.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'https://api.fallback.com';

  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  // static const String baseUrl = 'https://api.example.com';
  static const int timeoutSeconds = 30;
}
