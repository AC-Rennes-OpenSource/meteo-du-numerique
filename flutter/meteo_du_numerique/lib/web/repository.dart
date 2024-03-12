import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'data_model.dart';

const String v3url = "https://www.toutatice.fr/strapi/services";
const v4url = "https://www.toutatice.fr/strapi/api/services?populate=*";
const qtV4Url = "https://qt.toutatice.fr/strapi/api/services?populate=*";

List<Service> parseService(String responseBody) {
  List list;
  List<Service>? servicesList;
  list = json.decode(responseBody)['data'] as List<dynamic>;
  servicesList = list.map((e) => Service.fromJson(e)).toList();
  return servicesList;
}

List<Service> parseOldService(String responseBody) {
  List list;
  List<Service>? servicesList;
  list = json.decode(responseBody) as List<dynamic>;
  servicesList = list.map((e) => Service.fromV3Json(e)).toList();
  return servicesList;
}

Future<List<Service>> fetchServices() async {
  http.Response response = await http.get(Uri.parse(v4url));
  // TODO à retirer : tests qt
  // response = await http.get(Uri.parse(qtV4Url));
  if (response.statusCode == 200) {
    return compute(parseService, response.body);
  } else {
    response = await http.get(Uri.parse(v3url));
    if (response.statusCode == 200) {
      return compute(parseOldService, response.body);
    } else {
      throw Exception(response.statusCode);
    }
  }
}
