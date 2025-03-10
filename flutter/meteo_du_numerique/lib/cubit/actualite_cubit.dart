import 'package:bloc/bloc.dart';

import '../models/service_num_model.dart';
import '../services/api_service.dart';
import 'actualite_state.dart';

class ActualiteCubit extends Cubit<ActualiteState> {
  final ApiService apiService;

  String? currentSortCriteria;
  String? currentSortOrder = 'asc';
  List<String>? currentFilterCriteria = [];
  String? currentSearchQuery;
  DateTime? lastUpdate;

  ActualiteCubit({required this.apiService}) : super(ActualiteInitial());

  Future<void> fetchItems({bool showIndicator = true}) async {
    if (showIndicator) emit(ActualiteLoading());

    try {
      final serviceList = await _fetchFilteredAndSortedItems();
      if (serviceList.isNotEmpty) {
        lastUpdate = serviceList.map((e) => e.lastUpdate).reduce((min, e) => e.isAfter(min) ? e : min);
      }
      emit(ActualitesLoaded(actualitesList: serviceList, lastUpdate: lastUpdate));
    } catch (e) {
      emit(ActualiteError(message: e.toString()));
    }
  }

  void applyFilters(List<String> filters) {
    currentFilterCriteria = filters.isEmpty ? [] : filters;
    fetchItems(showIndicator: false);
    emit(ActualiteFiltered(showBadge: filters.isNotEmpty));
  }

  void applySorting(String? sortBy, String? order) {
    currentSortCriteria = sortBy;
    currentSortOrder = order;
    fetchItems(showIndicator: false);
  }

  void applySearch(String? query) {
    currentSearchQuery = query;
    fetchItems(showIndicator: false);
  }

  Future<List<ActualiteA>> _fetchFilteredAndSortedItems() async {
    var servicesList = await apiService.fetchItems();

    if (currentSearchQuery?.isNotEmpty == true) {
      servicesList = servicesList
          .where((service) => service.libelle.toLowerCase().contains(currentSearchQuery!.toLowerCase()))
          .toList();
    }

    if (currentFilterCriteria?.isNotEmpty == true) {
      servicesList = servicesList
          .where((service) => currentFilterCriteria!.contains(service.qualiteDeService?.libelle.toLowerCase()))
          .toList();
    }

    if (currentSortCriteria != null) {
      servicesList.sort((a, b) {
        compareField(service) => service.getField(currentSortCriteria!).toLowerCase();
        return currentSortOrder == 'asc'
            ? compareField(a).compareTo(compareField(b))
            : compareField(b).compareTo(compareField(a));
      });
    }

    return servicesList;
  }
}
