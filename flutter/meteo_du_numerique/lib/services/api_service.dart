import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:meteo_du_numerique/config.dart';

import '../models/service_num_model.dart';

class ApiService {
  final String baseUrl = Config.baseUrl;

  Future<List<Actualite>> fetchItems() async {
    debugPrint("Config.baseUrl : ${Config.baseUrl}");
    debugPrint("Config.urlAttributes : ${Config.urlAttributes}");
    try {
      final response = await http.get(Uri.parse(baseUrl + Config.urlAttributes));

      var act = getActu(_processResponse(response.body));
      return act;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('Failed to load services: $e');
    }
  }

  List<ServiceNum> _processResponse(String data) {
    // Décode la réponse JSON
    List<dynamic> jsonData = json.decode(data);

    // Transforme chaque élément en un objet ServiceNum
    return jsonData.map((item) {
      return ServiceNum.fromJson(item as Map<String, dynamic>);
    }).toList();
  }

  List<Actualite> getActu(List<ServiceNum> servList) {
    List<Actualite> listactus = [];
    for (var element in servList) {
      listactus.addAll(element.actualites);
    }
    return listactus;
  }
}
