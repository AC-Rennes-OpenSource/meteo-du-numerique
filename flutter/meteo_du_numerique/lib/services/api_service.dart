import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:meteo_du_numerique/config.dart';

import '../models/actualite_model.dart';
import '../models/prevision_model.dart';
import '../models/service_num_model.dart';

class ApiService {
  Future<List<Actualite>> fetchItems() async {
    try {
      final response = await http.get(Uri.parse(Config.baseUrl + Config.urlAttributes));

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

  fetchPrevisionsv5() async {
    // final url = Uri.parse('$baseUrl/api/service-numeriques?populate[previsions][populate]=*&populate[categorie]=*');
    // final url = Uri.parse('http://10.249.103.179:1337/api/service-numeriques?populate[previsions]=*&populate=categorie');
    final url = Uri.parse('https://qt.toutatice.fr/strapi5/api/mdn-service-numeriques?populate=*');
// todo conf env
    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la récupération des données : ${response.statusCode}');
      }

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Vérification que la réponse contient des données
      if (jsonResponse['data'] == null) {
        debugPrint('Aucune donnée trouvée dans la réponse.');
        return [];
      }

      final List<dynamic> services = jsonResponse['data'];
      final List<Prevision> allPrevisions = [];

      for (final service in services) {
        // Extraire les données de la catégorie
        final String categorieLibelle = service['mdn_categorie']?['libelle'] ?? 'Inconnu';
        final String categorieCouleur = service['mdn_categorie']?['couleur'] ?? 'Inconnu';

        // Extraire les prévisions
        final List<dynamic> previsions = service['mdn_previsions'] ?? [];

        allPrevisions.addAll(previsions.map((prevision) {
          return Prevision(
            id: prevision['id'].toString(),
            libelle: prevision['libelle'] ?? 'Inconnu',
            description: prevision['description'] ?? '',

            // description: prevision['description'] != null && prevision['description'] is List<dynamic>
            //     ? (prevision['description'][0]['children'][0]['text'] ?? '')
            //     : '',
            dateDebut: DateTime.parse(prevision['date_debut']),
            dateFin: DateTime.parse(prevision['date_fin']),
            categorieLibelle: categorieLibelle,
            couleur: categorieCouleur,
          );
        }));
      }

      return allPrevisions;
    } catch (e) {
      debugPrint('Erreur lors de la récupération des prévisions : $e');
      return [];
    }
  }
}
