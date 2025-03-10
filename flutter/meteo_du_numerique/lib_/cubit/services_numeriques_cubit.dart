
import 'package:bloc/bloc.dart';
import 'package:meteo_du_numerique/cubit/services_numeriques_state.dart';

import '../models/models.dart';
import '../services/mock-api-service.dart';

class ServicesNumeriquesCubit extends Cubit<ServicesNumeriquesState> {
  final MockApiService apiService;

  ServicesNumeriquesCubit(this.apiService) : super(ServicesNumeriquesState());

  Future<void> loadServices() async {

    //todo mock
    final jsonData = {
      'data': [
        {
          'id': 1,
          'attributes': {
            'libelle': 'Service A',
            'description': 'Description du service A',
            'lastUpdate': DateTime.now().toIso8601String(),
            'category': {
              'data': {
                'id': 1,
                'attributes': {
                  'libelle': 'Catégorie 1',
                  'color': 'jaune'
                }
              }
            },
            'qualiteDeService': {
              'data': {
                'id': 1,
                'attributes': {
                  'libelle': 'Bon',
                  'color': '#00FF00'
                }
              }
            }
          }
        }
      ]
    };

    final services = await apiService.getServicesNumeriques(jsonData: jsonData);

    emit(state.copyWith(allServices: services));
    _applyFilters();
  }

  void setQoSFilter(QualiteDeService? qos) {
    emit(state.copyWith(selectedQoS: qos));
    _applyFilters();
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    _applyFilters();
  }

  void toggleSortByState() {
    emit(state.copyWith(sortByState: !state.sortByState));
    _applyFilters();
  }

  void toggleSortByName() {
    emit(state.copyWith(sortByName: !state.sortByName));
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = state.allServices;

    // Apply QoS filter
    if (state.selectedQoS != null) {
      filtered = filtered.where((s) => s.qualiteDeService?.id == state.selectedQoS!.id).toList();
    }

    // Apply search query
    if (state.searchQuery.isNotEmpty) {
      filtered = filtered.where((s) =>
      s.libelle.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
          s.description.toLowerCase().contains(state.searchQuery.toLowerCase())
      ).toList();
    }

    // Apply sorting
    if (state.sortByState) {
      filtered.sort((a, b) => (a.qualiteDeService?.id ?? 0).compareTo(b.qualiteDeService?.id ?? 0));
    }
    if (state.sortByName) {
      filtered.sort((a, b) => a.libelle.compareTo(b.libelle));
    }

    emit(state.copyWith(filteredServices: filtered));
  }
}