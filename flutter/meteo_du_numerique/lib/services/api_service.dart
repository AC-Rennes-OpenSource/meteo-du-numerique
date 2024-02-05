import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import '../models/service_num_model.dart';
import '../models/service_num_model_old.dart';
import '../models/prevision_model.dart';

class ApiService {
  final String baseUrl = "https://www.toutatice.fr/strapi";

  final String v3url = "https://www.toutatice.fr/strapi/services";
  final v4url = "https://www.toutatice.fr/strapi/api/services?populate=*";
  final qtV4Url = "https://qt.toutatice.fr/strapi/api/services?populate=*";
  final localV4 = "http://localhost:1337/api";

  final String urlAttributes =
      '/services?populate[previsions]=*&populate[actualites][populate]=qualite_de_service&populate=categorie';

  Future<List<ServiceNumOld>> fetchItems({String? category, String? sortBy, String? query}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services'));
      return _processResponse(response.body, category, sortBy, query);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ActualiteA>> fetchMockItems() async {
    try {
      String data = await rootBundle.loadString('assets/mock2.json');
      return getActu(_processResponseServiceNum(data));
      // final response = await http.get(Uri.parse('$localV4$urlAttributes'));
      // return getActu(_processResponseServiceNum(response.body));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('Failed to load mock previsions: $e');
    }
  }

  List<ServiceNumOld> _processResponse(String data, String? filterBy, String? sortBy, String? query) {
    List<dynamic> jsonData = jsonDecode(data);
    List<ServiceNumOld> items = jsonData.map((item) => ServiceNumOld.fromJson(item)).toList();

    items.sort((a, b) => b.qualiteDeService.compareTo(a.qualiteDeService));
    if (filterBy != null) {
      if (filterBy.toLowerCase().contains("perturbations") || filterBy.toLowerCase().contains("fonctionnement")) {
        items = items.where((item) => item.qualiteDeService.toLowerCase().contains(filterBy)).toList();
      } else {
        items = items.where((item) => item.category == filterBy).toList();
      }
    }

    if (sortBy != null) {
      switch (sortBy) {
        case 'libelle':
          items.sort((a, b) => a.libelle.compareTo(b.libelle));
          break;
        case 'category':
          items.sort((a, b) => a.category.compareTo(b.category));
          break;
        case 'id':
          items.sort((a, b) => a.id.compareTo(b.id));
          break;
        case 'etat':
          items.sort((a, b) => b.qualiteDeServiceId.compareTo(b.qualiteDeServiceId));
          break;
        case 'qualiteDeService':
          items.sort((a, b) => b.qualiteDeService.compareTo(a.qualiteDeService));
          break;
        default:
        // Gérer le cas où 'sortBy' n'est pas un attribut valide
          break;
      }
    }

    // Searching
    if (query != null) {
      items = items.where((item) => item.libelle.toLowerCase().contains(query.toLowerCase())).toList();
    }

    return items;
  }

  //todo rst ----------------------------------------------------------

  Future<List<PrevisionA>> fetchMockPrevisions({String? category, String? sortBy, String? query}) async {
    try {
      String data = await rootBundle.loadString('assets/mock2.json');
      return getSortedPrev(_processResponseServiceNum(data));

      // final response = await http.get(Uri.parse('$localV4$urlAttributes'));
      // return getSortedPrev(_processResponseServiceNum(response.body));

      // todo old method
      // return _processResponsePrevisions(data, category, sortBy, query);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('Failed to load mock previsions: $e');
    }
  }

  List<Prevision> _processResponsePrevisions(String data, String? filterBy, String? sortBy, String? query) {
    List<dynamic> jsonData = json.decode(data)['data'] as List<dynamic>;

    List<Prevision> previsions = jsonData.map((prevision) => Prevision.fromJson(prevision)).toList();

    previsions.sort((a, b) {
      DateTime dateADebut = a.dateDebut;
      DateTime dateBDebut = b.dateDebut;
      return dateADebut.compareTo(dateBDebut);
    });
    return previsions;
  }

  List<ServiceNum> _processResponseServiceNum(String data) {
    List<dynamic> jsonData = json.decode(data)['data'] as List<dynamic>;

    List<ServiceNum> listeServicesNum = jsonData.map((e) => ServiceNum.fromJson(e)).toList();

    String prettyPrint = const JsonEncoder.withIndent('  ').convert(listeServicesNum);

    // print(prettyPrint);

    // getSortedPrev(listeServicesNum);

    // getActu(listeServicesNum, filterBy, sortBy, query);

    return listeServicesNum;
  }

  List<PrevisionA> getSortedPrev(List<ServiceNum> servList) {
    List<PrevisionA> listprev = [];
    for (var element in servList) {
      for (var prev in element.previsions) {
        prev.categorieLibelle = element.category.libelle;
        prev.couleur = element.category.color;
      }
      listprev.addAll(element.previsions);
    }

    listprev.sort((a, b) {
      DateTime dateADebut = a.dateDebut;
      DateTime dateBDebut = b.dateDebut;
      return dateADebut.compareTo(dateBDebut);
    });

    String prettyPrint = const JsonEncoder.withIndent('  ').convert(listprev);

    // print(prettyPrint);

    return listprev;
  }

  List<ActualiteA> getActu(List<ServiceNum> servList) {
    List<ActualiteA> listactus = [];
    for (var element in servList) {
      listactus.addAll(element.actualites);
    }

    String prettyPrint = const JsonEncoder.withIndent('  ').convert(listactus);

    print(prettyPrint);

    return listactus;
  }
}
