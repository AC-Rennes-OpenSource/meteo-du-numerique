import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:meteo_du_numerique/services/updatable.dart';

import 'api_mapper.dart'; // Importez vos mappers ici
import 'models.dart'; // Importez vos modèles ici

class ApiStrapiService {
  final String baseUrl;
  final ApiMapper mapper;

  ApiStrapiService({required this.baseUrl, required this.mapper});

  /// Récupère les prévisions depuis l'API et les mappe en objets `Forecast`
  Future<List<Forecast>> fetchForecasts() async {
    // todo final response = await http.get(Uri.parse('$baseUrl/forecasts'));
    final response = await http.get(Uri.parse('https://qt.toutatice.fr/strapi5/api/mdn-service-numeriques?populate=*'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return mapper.parseForecastsFromApiResponse(jsonResponse);
    } else {
      throw Exception('Erreur lors du chargement des prévisions : ${response.statusCode}');
    }
  }

  /// Récupère les actualités depuis l'API et les mappe en objets `News`
  Future<List<News>> fetchNews() async {
    // todo final response = await http.get(Uri.parse('$baseUrl/news'));
    final response = await http.get(Uri.parse('https://qt.toutatice.fr/strapi5/api/mdn-service-numeriques?populate=*'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return mapper.parseNewsFromApiResponse(jsonResponse);
    } else {
      throw Exception('Erreur lors du chargement des actualités : ${response.statusCode}');
    }
  }

  void logForecastsAndNews(List<Forecast> forecasts, List<News> news) {
    // Convertir les listes en JSON
    final forecastsJson = forecasts.map((forecast) => forecast.toJson()).toList();
    final newsJson = news.map((newsItem) => newsItem.toJson()).toList();

    // Convertir les objets JSON en chaînes structurées
    final formattedForecasts = const JsonEncoder.withIndent('  ').convert(forecastsJson);
    final formattedNews = const JsonEncoder.withIndent('  ').convert(newsJson);

    // Loguer les résultats dans la console
    debugPrint('Prévisions (JSON structuré) :\n$formattedForecasts');
    debugPrint('Actualités (JSON structuré) :\n$formattedNews');
  }

  /// Trouve l'objet le plus récent parmi les prévisions et actualités
  Future<dynamic> findMostRecent(List<Updatable> forecasts, List<Updatable> news) async {
    // Combinez toutes les prévisions et actualités dans une seule liste
    final allItems = [...forecasts, ...news];

    // Trouvez l'objet avec la date updatedAt la plus récente
    final mostRecentItem = allItems.reduce((a, b) {
      if (a.updatedAt.isAfter(b.updatedAt)) {
        return a;
      } else {
        return b;
      }
    });

    return mostRecentItem.updatedAt;
  }

  String lastUpdateString(DateTime? lastUpdate) {
    if(lastUpdate!=null){
      String form = DateFormat("dd MMMM yyyy", "fr_FR").format(lastUpdate);
      String hour =
          "${DateFormat("H").format(lastUpdate
        // .add(const Duration(hours: 2))
      )}h${DateFormat("mm").format(lastUpdate)}";
      return "Dernière mise à jour le $form à $hour";
    } else {
      return '';
    }

  }

}
