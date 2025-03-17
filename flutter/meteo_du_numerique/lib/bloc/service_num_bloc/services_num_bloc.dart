import 'package:bloc/bloc.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/cupertino.dart';
import 'package:meteo_du_numerique/models/service_num_model.dart';

import '../../models/service_num_model_old.dart';
import '../../services/api_service.dart';
import '../../utils.dart';
import 'services_num_event.dart';
import 'services_num_state.dart';

class ServicesNumBloc extends Bloc<ServicesNumEvent, ServicesNumState> {
  final ApiService apiService;
  final bool useMockData;

  String? currentSortCriteria = 'qualiteDeServiceId';
  String? currentSortOrder = 'desc';
  List<String>? currentFilterCriteria = [];
  String? currentSearchQuery;
  late DateTime lastUpdate;

  List<String> currentFilters = [];

  ServicesNumBloc({required this.apiService, this.useMockData = true}) : super(ServicesNumInitial()) {
    on<FetchServicesNumEvent>(_onFetchItems);
    on<FilterServicesNumEvent>(_onFilterItems);
    on<SortServicesNumEvent>(_onSortItems);
    on<SearchItemsEvent>(_onSearchItems);
  }

  @override
  void onChange(Change<ServicesNumState> change) {
    super.onChange(change);
  }

  @override
  void onTransition(Transition<ServicesNumEvent, ServicesNumState> transition) {
    super.onTransition(transition);
  }

  Future<void> _onFetchItems(FetchServicesNumEvent event, Emitter<ServicesNumState> emit) async {
    //TODO
    debugPrint("here _onFetchItems __________________________");

    if (event.showIndicator) {
      emit(ServicesNumLoading());
    }

    // TODO : délai pour test
    // await Future.delayed(const Duration(milliseconds: 250));

    try {
      await _getItems().then((serviceList) {
        // if (serviceList.isNotEmpty) {
        //   lastUpdate = serviceList.map((e) => e.lastUpdate).reduce((min, e) => e.isAfter(min) ? e : min);
        //   // DateTime.now();
        // }
        emit(ServicesNumLoaded(servicesList: serviceList, lastUpdate: lastUpdate));
      });
    } catch (e) {
      emit(ServicesNumError(message: e.toString()));
    }
  }

  void _onFilterItems(FilterServicesNumEvent event, Emitter<ServicesNumState> emit) async {
    if (event.filterBy == []) {
      resetCriteria();
      currentFilters = [];

      emit(ServicesNumFiltered(showBadge: false));
    } else {
      currentFilterCriteria = event.filterBy;
      currentFilters = currentFilterCriteria!;

      emit(ServicesNumFiltered(showBadge: true));
    }

    add(FetchServicesNumEvent());
  }

  void _onSortItems(SortServicesNumEvent event, Emitter<ServicesNumState> emit) async {
    // resetCriteria();
    currentSortCriteria = event.sortBy;
    currentSortOrder = event.order;
    add(FetchServicesNumEvent());
  }

  void _onSearchItems(SearchItemsEvent event, Emitter<ServicesNumState> emit) async {
    // resetCriteria();
    currentSearchQuery = event.query;
    add(FetchServicesNumEvent());
  }

  void resetCriteria() {
    currentSortCriteria = null;
    currentFilterCriteria = [];
    currentSearchQuery = null;
    add(FetchServicesNumEvent());
  }

  Future<List<ServiceNumOld>> _getItems_v3() async {
    List<ServiceNumOld> servicesList;

    servicesList = await apiService.fetchItems_v3();

    // search filter
    if (currentSearchQuery != null && currentSearchQuery!.isNotEmpty) {
      servicesList = servicesList.where((serviceNum) => serviceNum.libelle.toLowerCase().contains(currentSearchQuery!.toLowerCase())).toList();
    }

    // category filter
    if (currentFilterCriteria != null && currentFilterCriteria!.isNotEmpty) {
      List<ServiceNumOld> itemupdate = [];
      currentFilterCriteria?.forEach((element) {
        itemupdate.addAll(servicesList.where((serviceNum) => serviceNum.qualiteDeService.toLowerCase() == element).toList());
      });
      servicesList = itemupdate;
    }

    // Apply sorting
    if (currentSortCriteria != null) {
      if (currentSortCriteria == "qualiteDeServiceId") {
        if (currentSortOrder == 'asc') {
          servicesList.sort((a, b) => a.getField(currentSortCriteria!).compareTo(b.getField(currentSortCriteria!)));
        } else {
          servicesList.sort((b, a) => a.getField(currentSortCriteria!).compareTo(b.getField(currentSortCriteria!)));
        }
      } else {
        if (currentSortOrder == 'asc') {
          servicesList.sort((a, b) => removeDiacritics(a.getField(currentSortCriteria!).toLowerCase())
              .compareTo(removeDiacritics(b.getField(currentSortCriteria!).toLowerCase())));
        } else {
          servicesList.sort((b, a) => removeDiacritics(a.getField(currentSortCriteria!).toLowerCase())
              .compareTo(removeDiacritics(b.getField(currentSortCriteria!).toLowerCase())));
        }
      }
    }

    return servicesList;
  }

  Future<List<ActualiteA>> _getItems() async {
    List<ActualiteA> servicesList;

    servicesList = await apiService.fetchItems();

    // TODO mock/stub
    // servicesList = await apiService.fetchMockItems();
    // set lastUpdate
    lastUpdate = servicesList.map((e) => e.lastUpdate).reduce((min, e) => e.isAfter(min) ? e : min);

    // search filter
    if (currentSearchQuery != null && currentSearchQuery!.isNotEmpty) {
      servicesList =
          servicesList.where((serviceNum) => Utils.normalizeText(serviceNum.libelle).contains(Utils.normalizeText(currentSearchQuery!))).toList();
    }

    // category filter
    if (currentFilterCriteria != null && currentFilterCriteria!.isNotEmpty) {
      List<ActualiteA> itemupdate = [];
      currentFilterCriteria?.forEach((element) {
        itemupdate.addAll(servicesList.where((serviceNum) => serviceNum.qualiteDeService?.libelle.toLowerCase() == element).toList());
      });
      servicesList = itemupdate;
    }

    // tri par ordre alphabetique a --> z
    servicesList
        .sort((a, b) => removeDiacritics(a.getField("libelle").toLowerCase()).compareTo(removeDiacritics(b.getField("libelle").toLowerCase())));

    // sorting
    if (currentSortCriteria != null) {
      if (currentSortCriteria == "qualiteDeServiceId") {
        if (currentSortOrder == 'asc') {
          servicesList.sort((a, b) {
            // Comparaison par niveauQos (ordre croissant)
            int result = a.qualiteDeService!.niveauQos.compareTo(b.qualiteDeService!.niveauQos);

            // Si niveauQos est identique, trier par ordre alphabétique sur le libellé
            if (result == 0) {
              return removeDiacritics(a.getField("libelle").toLowerCase()).compareTo(removeDiacritics(b.getField("libelle").toLowerCase()));
            }
            return result;
          });
        } else {
          servicesList.sort((a, b) {
            // Comparaison par niveauQos (ordre croissant)
            int result = b.qualiteDeService!.niveauQos.compareTo(a.qualiteDeService!.niveauQos);

            // Si niveauQos est identique, trier par ordre alphabétique sur le libellé
            if (result == 0) {
              return removeDiacritics(a.getField("libelle").toLowerCase()).compareTo(removeDiacritics(b.getField("libelle").toLowerCase()));
            }
            return result;
          });
        }
      } else {
        if (currentSortOrder == 'desc') {
          servicesList.sort((b, a) => removeDiacritics(a.getField(currentSortCriteria!).toLowerCase())
              .compareTo(removeDiacritics(b.getField(currentSortCriteria!).toLowerCase())));
        }
      }
    }

    return servicesList ?? [];
  }
}
