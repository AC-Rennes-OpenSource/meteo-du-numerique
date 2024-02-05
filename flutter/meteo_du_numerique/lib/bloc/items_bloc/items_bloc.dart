import 'package:bloc/bloc.dart';
import 'package:diacritic/diacritic.dart';
import 'package:meteo_du_numerique/models/service_num_model.dart';

import '../../models/service_num_model_old.dart';
import '../../services/api_service.dart';
import 'items_event.dart';
import 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final ApiService apiService;
  final bool useMockData;

  String? currentSortCriteria = 'qualiteDeServiceId';
  String? currentSortOrder = 'desc';
  List<String>? currentFilterCriteria;
  String? currentSearchQuery;
  late DateTime? lastUpdate = DateTime.now();

  List<String> currentFilters = [];

  ItemsBloc({required this.apiService, this.useMockData = false}) : super(ItemsInitial()) {
    on<FetchItemsEvent>(_onFetchItems);
    on<FilterItemsEvent>(_onFilterItems);
    on<SortItemsEvent>(_onSortItems);
    on<SearchItemsEvent>(_onSearchItems);
  }

  Future<void> _onFetchItems(FetchItemsEvent event, Emitter<ItemsState> emit) async {
    if (event.showIndicator) {
      emit(ItemsLoading());
    }

    // todo rst : délai pour test
    await Future.delayed(const Duration(milliseconds: 250));

    try {
      final items = await _getItems();
      emit(ItemsLoaded(items: items));
      lastUpdate = items.map((e) => e.lastUpdate).reduce((min, e) => e.isAfter(min) ? e : min);
    } catch (e) {
      emit(ItemsError(message: e.toString()));
    }
  }

  void _onFilterItems(FilterItemsEvent event, Emitter<ItemsState> emit) async {
    if (event.filterBy == []) {
      resetCriteria();
      currentFilters = [];
    } else {
      currentFilterCriteria = event.filterBy;
      currentFilters = currentFilterCriteria!;
    }
    add(FetchItemsEvent());
  }

  void _onSortItems(SortItemsEvent event, Emitter<ItemsState> emit) async {
    // resetCriteria();
    currentSortCriteria = event.sortBy;
    currentSortOrder = event.order;
    add(FetchItemsEvent());
  }

  void _onSearchItems(SearchItemsEvent event, Emitter<ItemsState> emit) async {
    // resetCriteria();
    currentSearchQuery = event.query;
    add(FetchItemsEvent());
  }

  void resetCriteria() {
    currentSortCriteria = null;
    currentFilterCriteria = [];
    currentSearchQuery = null;
    add(FetchItemsEvent());
  }

  Future<List<ServiceNumOld>> _getItemsOld() async {
    List<ServiceNumOld> items;

    items = await apiService.fetchItems();
    // await (useMockData
    //     ? apiService.fetchMockItems()
    //     : apiService.fetchItems();
    // );

    // search filter
    if (currentSearchQuery != null && currentSearchQuery!.isNotEmpty) {
      items = items.where((item) => item.libelle.toLowerCase().contains(currentSearchQuery!.toLowerCase())).toList();
    }

    // category filter
    if (currentFilterCriteria != null && currentFilterCriteria!.isNotEmpty) {
      List<ServiceNumOld> itemupdate = [];
      currentFilterCriteria?.forEach((element) {
        itemupdate.addAll(items.where((item) => item.qualiteDeService.toLowerCase() == element).toList());
      });
      items = itemupdate;
    }

    // Apply sorting
    if (currentSortCriteria != null) {
      if (currentSortCriteria == "qualiteDeServiceId") {
        if (currentSortOrder == 'asc') {
          items.sort((a, b) => a.getField(currentSortCriteria!).compareTo(b.getField(currentSortCriteria!)));
        } else {
          items.sort((b, a) => a.getField(currentSortCriteria!).compareTo(b.getField(currentSortCriteria!)));
        }
      } else {
        if (currentSortOrder == 'asc') {
          items.sort((a, b) =>
              removeDiacritics(a.getField(currentSortCriteria!).toLowerCase())
                  .compareTo(removeDiacritics(b.getField(currentSortCriteria!).toLowerCase())));
        } else {
          items.sort((b, a) =>
              removeDiacritics(a.getField(currentSortCriteria!).toLowerCase())
                  .compareTo(removeDiacritics(b.getField(currentSortCriteria!).toLowerCase())));
        }
      }
    }

    return items;
  }

  Future<List<ActualiteA>> _getItems() async {
    List<ActualiteA> items;

    items = await apiService.fetchMockItems();
    // await (useMockData
    //     ? apiService.fetchMockItems()
    //     : apiService.fetchItems();
    // );

    // search filter
    if (currentSearchQuery != null && currentSearchQuery!.isNotEmpty) {
      items = items.where((item) => item.libelle.toLowerCase().contains(currentSearchQuery!.toLowerCase())).toList();
    }

    // category filter
    if (currentFilterCriteria != null && currentFilterCriteria!.isNotEmpty) {
      List<ActualiteA> itemupdate = [];
      currentFilterCriteria?.forEach((element) {
        itemupdate.addAll(items.where((item) => item.qualiteDeService?.libelle.toLowerCase() == element).toList());
      });
      items = itemupdate;
    }

    // Apply sorting
    if (currentSortCriteria != null) {
      if (currentSortCriteria == "qualiteDeServiceId") {
        if (currentSortOrder == 'asc') {
          items.sort((a, b) => a.qualiteDeService!.id.compareTo(b.qualiteDeService!.id));
        } else {
          items.sort((b, a) => a.qualiteDeService!.id.compareTo(b.qualiteDeService!.id));
        }
      } else {
        if (currentSortOrder == 'asc') {
          items.sort((a, b) =>
              removeDiacritics(a.getField(currentSortCriteria!).toLowerCase())
                  .compareTo(removeDiacritics(b.getField(currentSortCriteria!).toLowerCase())));
        } else {
          items.sort((b, a) =>
              removeDiacritics(a.getField(currentSortCriteria!).toLowerCase())
                  .compareTo(removeDiacritics(b.getField(currentSortCriteria!).toLowerCase())));
        }
      }
    }

    return items;
  }
}
