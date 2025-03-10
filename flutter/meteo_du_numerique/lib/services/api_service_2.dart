import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:meteo_du_numerique/config.dart';

import '../models/service_num_model.dart';
import '../models/service_num_model_old.dart';

class ApiService {
  final String baseUrl = Config.baseUrl;

  Future<List<ActualiteA>> fetchItems() async {
    debugPrint("Config.baseUrl : ${Config.baseUrl}");
    debugPrint("Config.urlAttributes : ${Config.urlAttributes}");
    try {
      final response =
          await http.get(Uri.parse(baseUrl + Config.urlAttributes));

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
  Future<List<PrevisionA>> fetchPrevisions(
      {String? category, String? sortBy, String? query}) async {
    try {
      final response =
          await http.get(Uri.parse(baseUrl + Config.urlAttributes));
      var b = _processResponse(response.body);
      var a = getSortedPrev(b);
      return a;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('Failed to load mock previsions: $e');
    }
  }

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

  List<PrevisionA> getSortedPrev(List<ServiceNum> servList) {
    List<PrevisionA> listprev = [];
    for (var element in servList) {
      for (var prev in element.groupedPrevisions) {
        prev.categorieLibelle = element.category.libelle;
        // print(prev.categorieLibelle);
        prev.couleur = element.category.color;
        // print(prev.couleur);
        // print(prev);
        // TODO affiche uniquement si après aujourd'hui (à garder?)
        // if (prev.dateDebut.isAfter(DateTime.now())) {
          listprev.add(prev);
        // }
      }
    }
    if (listprev.isNotEmpty) {

      // TODO test pour affichage de la prévision du jour dans la tab 1
       listprev.first.dateDebut = DateTime.now();

      listprev.sort((a, b) {
        DateTime dateADebut = a.dateDebut;
        DateTime dateBDebut = b.dateDebut;
        return dateADebut.compareTo(dateBDebut);
      });
    }
    return listprev;
  }

  List<ActualiteA> getActu(List<ServiceNum> servList) {
    List<ActualiteA> listactus = [];
    for (var element in servList) {
      listactus.addAll(element.actualites);
    }
    return listactus;
  }

  //---------------------------------------------------------------------------------------------------
  Future<List<ServiceNumOld>> fetchItems_v3(
      {String? category, String? sortBy, String? query}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services'));
      return _processResponse_v3(response.body, category, sortBy, query);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  List<ServiceNumOld> _processResponse_v3(
      String data, String? filterBy, String? sortBy, String? query) {
    List<dynamic> jsonData = jsonDecode(data);
    List<ServiceNumOld> servicesList = jsonData
        .map((serviceNum) => ServiceNumOld.fromJson(serviceNum))
        .toList();

    servicesList
        .sort((a, b) => b.qualiteDeService.compareTo(a.qualiteDeService));

    // filtering
    if (filterBy != null) {
      if (filterBy.toLowerCase().contains("perturbations") ||
          filterBy.toLowerCase().contains("fonctionnement")) {
        servicesList = servicesList
            .where((serviceNum) =>
                serviceNum.qualiteDeService.toLowerCase().contains(filterBy))
            .toList();
      } else {
        servicesList = servicesList
            .where((serviceNum) => serviceNum.category == filterBy)
            .toList();
      }
    }

    // sorting
    if (sortBy != null) {
      switch (sortBy) {
        case 'libelle':
          servicesList.sort((a, b) => a.libelle.compareTo(b.libelle));
          break;
        case 'category':
          servicesList.sort((a, b) => a.category.compareTo(b.category));
          break;
        case 'id':
          servicesList.sort((a, b) => a.id.compareTo(b.id));
          break;
        case 'etat':
          servicesList.sort(
              (a, b) => b.qualiteDeServiceId.compareTo(b.qualiteDeServiceId));
          break;
        case 'qualiteDeService':
          servicesList
              .sort((a, b) => b.qualiteDeService.compareTo(a.qualiteDeService));
          break;
        default:
          // TODO Gérer le cas où 'sortBy' n'est pas un attribut valide
          break;
      }
    }

    // Searching
    if (query != null) {
      servicesList = servicesList
          .where((serviceNum) =>
              serviceNum.libelle.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    return servicesList;
  }

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
