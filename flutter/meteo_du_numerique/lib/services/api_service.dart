import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:meteo_du_numerique/config.dart';

import '../models/service_num_model.dart';

class ApiService {
  final String baseUrl = Config.baseUrl;

  Future<List<ActualiteA>> fetchItems() async {
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

  //TODO : séparer les appels serviceNums/prévisions ----------------------------------------------------------
  // Future<List<PrevisionA>> fetchPrevisions(
  //     {String? category, String? sortBy, String? query}) async {
  //   try {
  //     final response =
  //         await http.get(Uri.parse(baseUrl + Config.urlAttributes));
  //     var b = _processResponse(response.body);
  //     var a = getSortedPrev(b);
  //     return a;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     throw Exception('Failed to load mock previsions: $e');
  //   }
  // }

  // List<ServiceNum> _processResponse(String data) {
  //   // List<dynamic> jsonData = json.decode(data)['data'] as List<dynamic>;
  //   List<dynamic> jsonData = json.decode(data) as List<dynamic>;
  //   // TODO json-server sert un tableau : nécessité de prendre le 1er élément
  //   // List<dynamic> jsonData = json.decode(data)['data'] as List<dynamic>;
  //   List<ServiceNum> listeServicesNum =
  //       jsonData.map((e) => ServiceNum.fromJson(e)).toList();
  //   return listeServicesNum;
  // }

  List<ServiceNum> _processResponse(String data) {
    // Décoder la réponse JSON
    List<dynamic> jsonData = json.decode(data);

    // Transformer chaque élément en un objet ServiceNum
    return jsonData.map((item) {
      return ServiceNum.fromJson(item as Map<String, dynamic>);
    }).toList();
  }

  // List<PrevisionA> getSortedPrev(List<ServiceNum> servList) {
  //   List<PrevisionA> listprev = [];
  //   for (var element in servList) {
  //     for (var prev in element.previsions) {
  //       prev.categorieLibelle = element.category.libelle;
  //       // print(prev.categorieLibelle);
  //       prev.couleur = element.category.color;
  //       // print(prev.couleur);
  //       // print(prev);
  //       // TODO affiche uniquement si après aujourd'hui (à garder?)
  //       // if (prev.dateDebut.isAfter(DateTime.now())) {
  //         listprev.add(prev);
  //       // }
  //     }
  // }
  //   if (listprev.isNotEmpty) {
  //
  //     // TODO test pour affichage de la prévision du jour dans la tab 1
  //      listprev.first.dateDebut = DateTime.now();
  //
  //     listprev.sort((a, b) {
  //       DateTime dateADebut = a.dateDebut;
  //       DateTime dateBDebut = b.dateDebut;
  //       return dateADebut.compareTo(dateBDebut);
  //     });
  //   }
  //   return listprev;
  // }

  List<ActualiteA> getActu(List<ServiceNum> servList) {
    List<ActualiteA> listactus = [];
    for (var element in servList) {
      listactus.addAll(element.actualites);
    }
    return listactus;
  }

  //---------------------------------------------------------------------------------------------------
  // Ces méthodes ont été supprimées car elles dépendaient du modèle ServiceNumOld qui n'existe plus

  Future<List<ActualiteA>> fetchMockItems() async {
    try {
      String data = await rootBundle.loadString('assets/stub.json');
      var a = _processResponse(data);
      var b = getActu(a);
      return b;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('Failed to load mock services: $e');
    }
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
      final List<PrevisionA> allPrevisions = [];

      for (final service in services) {
        // Extraire les données de la catégorie
        final String categorieLibelle = service['mdn_categorie']?['libelle'] ?? 'Inconnu';
        final String categorieCouleur = service['mdn_categorie']?['couleur'] ?? 'Inconnu';

        // Extraire les prévisions
        final List<dynamic> previsions = service['mdn_previsions'] ?? [];

        allPrevisions.addAll(previsions.map((prevision) {
          return PrevisionA(
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
// Future<List<PrevisionA>> fetchMockPrevisions(
//     {String? category, String? sortBy, String? query}) async {
//   try {
//     String data = await rootBundle.loadString('assets/stub.json');
//     return getSortedPrev(_processResponse(data));
//   } catch (e) {
//     if (kDebugMode) {
//       print(e);
//     }
//     throw Exception('Failed to load mock previsions: $e');
//   }
// }
//---------------------------------------------------------------------------------------------------
  }
