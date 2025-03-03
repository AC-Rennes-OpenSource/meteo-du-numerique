import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diacritic/diacritic.dart';

import '../../../data/models/digital_service.dart';
import '../../../data/models/service_quality.dart';
import '../../../data/repositories/digital_services_repository.dart';
import '../../../data/sources/api_client.dart';
import 'digital_services_event.dart';
import 'digital_services_state.dart';

class DigitalServicesBloc extends Bloc<DigitalServicesEvent, DigitalServicesState> {
  String? currentSortCriteria = 'serviceQualityId';
  String? currentSortOrder = 'desc';
  List<String>? currentFilterCriteria = [];
  String? currentSearchQuery;
  DateTime lastUpdate = DateTime.now();

  List<String> currentFilters = [];
  
  // Repository for fetching digital services
  final DigitalServicesRepository _repository;
  final bool useMockData;

  DigitalServicesBloc({
    DigitalServicesRepository? repository,
    this.useMockData = false // Set to false to use the real API by default
  }) 
      : _repository = repository ?? DigitalServicesRepositoryImpl(ApiClient()),
        super(DigitalServicesInitial()) {
    on<FetchDigitalServicesEvent>(_onFetchItems);
    on<FilterDigitalServicesEvent>(_onFilterItems);
    on<SortDigitalServicesEvent>(_onSortItems);
    on<SearchDigitalServicesEvent>(_onSearchItems);
  }

  Future<void> _onFetchItems(FetchDigitalServicesEvent event, Emitter<DigitalServicesState> emit) async {
    if (event.showIndicator) {
      emit(DigitalServicesLoading());
    }

    try {
      final services = await _getItems();
      emit(DigitalServicesLoaded(services: services, lastUpdate: lastUpdate));
    } catch (e) {
      emit(DigitalServicesError(message: e.toString()));
    }
  }

  void _onFilterItems(FilterDigitalServicesEvent event, Emitter<DigitalServicesState> emit) {
    currentFilterCriteria = event.categories;
    currentFilters = currentFilterCriteria?.map((e) => e.toString()).toList() ?? [];
    add(FetchDigitalServicesEvent());
  }

  void _onSortItems(SortDigitalServicesEvent event, Emitter<DigitalServicesState> emit) {
    currentSortCriteria = event.sortBy;
    currentSortOrder = event.order;
    add(FetchDigitalServicesEvent());
  }

  void _onSearchItems(SearchDigitalServicesEvent event, Emitter<DigitalServicesState> emit) {
    currentSearchQuery = event.query;
    add(FetchDigitalServicesEvent());
  }

  void resetCriteria() {
    currentSortCriteria = null;
    currentFilterCriteria = [];
    currentSearchQuery = null;
  }

  Future<List<DigitalService>> _getItems() async {
    // Get services from repository
    List<DigitalService> services = await _repository.getDigitalServices(useMock: useMockData);
    lastUpdate = DateTime.now();
    
    // Apply search filter
    if (currentSearchQuery != null && currentSearchQuery!.isNotEmpty) {
      final normalizedQuery = removeDiacritics(currentSearchQuery!.toLowerCase());
      services = services
          .where((service) => 
              removeDiacritics(service.name?.toLowerCase() ?? '')
                  .contains(normalizedQuery) ||
              removeDiacritics(service.description?.toLowerCase() ?? '')
                  .contains(normalizedQuery))
          .toList();
    }

    // Apply category filter
    if (currentFilterCriteria != null && currentFilterCriteria!.isNotEmpty) {
      List<DigitalService> filteredServices = [];
      for (var quality in currentFilterCriteria!) {
        filteredServices.addAll(
          services.where((service) => 
            service.qualityOfService?.id.toString() == quality
          ).toList()
        );
      }
      services = filteredServices;
    }

    // Apply sorting
    if (currentSortCriteria != null) {
      if (currentSortCriteria == "serviceQualityId") {
        if (currentSortOrder == 'asc') {
          services.sort((a, b) => (a.qualityOfService?.id ?? 0)
              .compareTo(b.qualityOfService?.id ?? 0));
        } else {
          services.sort((b, a) => (a.qualityOfService?.id ?? 0)
              .compareTo(b.qualityOfService?.id ?? 0));
        }
      } else if (currentSortCriteria == "name") {
        if (currentSortOrder == 'asc') {
          services.sort((a, b) => 
              removeDiacritics((a.name ?? '').toLowerCase())
              .compareTo(removeDiacritics((b.name ?? '').toLowerCase())));
        } else {
          services.sort((b, a) => 
              removeDiacritics((a.name ?? '').toLowerCase())
              .compareTo(removeDiacritics((b.name ?? '').toLowerCase())));
        }
      } else if (currentSortCriteria == "updatedAt") {
        if (currentSortOrder == 'asc') {
          services.sort((a, b) => 
              (a.updatedAt ?? DateTime(1970))
              .compareTo(b.updatedAt ?? DateTime(1970)));
        } else {
          services.sort((b, a) => 
              (a.updatedAt ?? DateTime(1970))
              .compareTo(b.updatedAt ?? DateTime(1970)));
        }
      }
    }

    return services;
  }
}