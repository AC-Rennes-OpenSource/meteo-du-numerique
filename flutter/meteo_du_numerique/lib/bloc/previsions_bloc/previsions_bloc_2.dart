import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:meteo_du_numerique/models/service_num_model.dart';
import 'package:meteo_du_numerique/services/api_service.dart';
import 'package:meteo_du_numerique/utils.dart';

import 'previsions_event.dart';
import 'previsions_state.dart';

class PrevisionsBloc extends Bloc<PrevisionsEvent, PrevisionsState> {
  final ApiService apiService;
  final bool useMockData;

  String? currentSortCriteria = 'dateDebut';
  String? currentSortOrder = 'asc';
  List<String>? currentFilterCriteria = [];
  String? currentSearchQuery;
  Map<int, Map<String, bool>> groupState = {};
  Map<int, Map<String, bool>> dayGroupState = {};
  bool enablePrevisionsGroups = true;
  String currentPeriode = 'all';

  List<String> currentFilters = [];

  PrevisionsBloc({required this.apiService, this.useMockData = true}) : super(PrevisionsInitial()) {
    _initGroupState();

    on<FetchPrevisionsEvent>(_onFetchItems);
    on<FilterPrevisionsEvent>(_onFilterItems);
    on<SortPrevisionsEvent>(_onSortItems);
    on<SearchPrevisionsEvent>(_onSearchItems);
    on<TogglePrevisionGroupEvent>(_onToggleGroup);
    on<ToggleDayPrevisionGroupEvent>(_onToggleDayGroup);
  }

  Future<void> _initGroupState() async {
    DateTime refDate = DateTime.now();
    for (var i = 0; i < 12; i++) {
      DateTime monthDate = DateTime(refDate.year, refDate.month + i, 1);
      final month = monthDate.month;
      final year = monthDate.year;
      groupState[year] ??= {};
      groupState[year]![month.toString()] = true;
    }
    for (var i = 0; i < 7; i++) {
      DateTime dayDate = DateTime.now().add(Duration(days: i));
      final day = dayDate.day;
      final month = dayDate.month;
      final year = dayDate.year;
      dayGroupState[year] ??= {};
      dayGroupState[year]!["$month-$day"] = true;
    }
  }

  void _updateGroupState(String month, int year) {
    groupState[year] ??= {};
    groupState[year]![month] = !(groupState[year]![month] ?? false);
  }

  // Note: This method is kept for potential future use
  // but may be safely removed if no longer needed
  // void _updateDayGroupState(String dayKey, int year) {
  //   dayGroupState[year] ??= {};
  //   dayGroupState[year]![dayKey] = !(dayGroupState[year]![dayKey] ?? false);
  // }

  void _onToggleGroup(TogglePrevisionGroupEvent event, Emitter<PrevisionsState> emit) {
    final month = event.month;
    final year = int.parse(event.year);
    _updateGroupState(month, year);
    _fetchPrevisions(emit);
  }

  void _onToggleDayGroup(ToggleDayPrevisionGroupEvent event, Emitter<PrevisionsState> emit) {
    enablePrevisionsGroups = !enablePrevisionsGroups;
    _fetchPrevisions(emit);
  }

  Future<void> _onFetchItems(FetchPrevisionsEvent event, Emitter<PrevisionsState> emit) async {
    if (event.showIndicator) {
      emit(PrevisionsLoading());
    }
    await _fetchPrevisions(emit);
  }

  Future<void> _fetchPrevisions(Emitter<PrevisionsState> emit) async {
    try {
      final serviceList = await _getPrevItems();
      emit(PrevisionsLoaded(
          servicesList: serviceList,
          groupsByDateDebut: _getGroupsByDateDebut(serviceList),
          groupsByMonth: _getGroupsMonths(serviceList)));
    } catch (e) {
      emit(PrevisionsError(message: e.toString()));
    }
  }

  void _onFilterItems(FilterPrevisionsEvent event, Emitter<PrevisionsState> emit) {
    if (event.categories.isEmpty && event.periode == 'all') {
      resetCriteria();
      currentFilters = [];
      emit(PrevisionsFiltered());
    } else {
      currentFilterCriteria = event.categories;
      currentFilters = currentFilterCriteria!;
      currentPeriode = event.periode;
      emit(PrevisionsFiltered());
    }
    _fetchPrevisions(emit);
  }

  void _onSortItems(SortPrevisionsEvent event, Emitter<PrevisionsState> emit) {
    currentSortCriteria = event.sortBy;
    currentSortOrder = event.order;
    _fetchPrevisions(emit);
  }

  void _onSearchItems(SearchPrevisionsEvent event, Emitter<PrevisionsState> emit) {
    currentSearchQuery = event.query;
    _fetchPrevisions(emit);
  }

  Future<List<PrevisionA>> _getPrevItems() async {
    List<PrevisionA> previsionsList;

    previsionsList = await fetchPrevisionsV5();

    // search filter
    if (currentSearchQuery != null && currentSearchQuery!.isNotEmpty) {
      previsionsList = previsionsList
          .where((prevision) => Utils.normalizeText(prevision.libelle).contains(Utils.normalizeText(currentSearchQuery!)))
          .toList();
    }

    // category filter
    if (currentFilterCriteria != null && currentFilterCriteria!.isNotEmpty) {
      List<PrevisionA> itemupdate = [];
      currentFilterCriteria?.forEach((element) {
        itemupdate.addAll(previsionsList.where((prevision) => prevision.categorieLibelle.toLowerCase() == element).toList());
      });

      previsionsList = itemupdate;
    }

    // sorting
    if (currentSortCriteria != null) {
      if (currentSortCriteria == "dateDebut") {
        if (currentSortOrder == 'asc') {
          previsionsList.sort((a, b) => a.dateDebut.compareTo(b.dateDebut));
        } else {
          previsionsList.sort((b, a) => a.dateDebut.compareTo(b.dateDebut));
        }
      } else {
        if (currentSortOrder == 'asc') {
          previsionsList.sort((a, b) => removeDiacritics(a.getField(currentSortCriteria!).toString().toLowerCase())
              .compareTo(removeDiacritics(b.getField(currentSortCriteria!).toString().toLowerCase())));
        } else {
          previsionsList.sort((b, a) => removeDiacritics(a.getField(currentSortCriteria!).toString().toLowerCase())
              .compareTo(removeDiacritics(b.getField(currentSortCriteria!).toString().toLowerCase())));
        }
      }
    }
    return previsionsList;
  }

  Map<String, List<PrevisionA>> _getGroupsByDateDebut(List<PrevisionA> prevList) {
    Map<String, List<PrevisionA>> groupedLists = {};

    // Filter by enabled days
    if (enablePrevisionsGroups) {
      for (PrevisionA prev in prevList) {
        // Find which group this belongs to
        final dateStr = Utils.formatDateFrHuman(prev.dateDebut);
        if (groupedLists.containsKey(dateStr)) {
          groupedLists[dateStr]!.add(prev);
        } else {
          groupedLists[dateStr] = [prev];
        }
      }
    } else {
      // Just one big list
      groupedLists = {'Toutes les prévisions': prevList};
    }

    return groupedLists;
  }

  Map<String, List<PrevisionA>> _getGroupsMonths(List<PrevisionA> prevList) {
    Map<String, List<PrevisionA>> groupedLists = {};

    // Format for month + year (we'll sort this later)
    for (PrevisionA prev in prevList) {
      // Only include if the day group is enabled
      DateTime date = prev.dateDebut;
      final String monthYearText = DateFormat.yMMMM('fr').format(date);

      if (groupState[date.year]?[date.month.toString()] == true) {
        // Include this item
        if (groupedLists.containsKey(monthYearText)) {
          groupedLists[monthYearText]!.add(prev);
        } else {
          groupedLists[monthYearText] = [prev];
        }
      }
    }

    // Sort the groups by date (need to convert back to date objects)
    var sortedKeys = groupedLists.keys.toList()
      ..sort((a, b) {
        // Extract month/year from string
        DateTime dateA = DateFormat.yMMMM('fr').parse(a);
        DateTime dateB = DateFormat.yMMMM('fr').parse(b);
        return dateA.compareTo(dateB);
      });

    // Create a new ordered map
    Map<String, List<PrevisionA>> sortedGroups = {};
    for (var key in sortedKeys) {
      sortedGroups[key] = groupedLists[key]!;
    }

    return sortedGroups;
  }

  void resetCriteria() {
    currentSortCriteria = null;
    currentFilterCriteria = [];
    currentSearchQuery = null;
    currentPeriode = 'all';
  }

  Future<List<PrevisionA>> fetchMockPrevisions() async {
    try {
      String data = await rootBundle.loadString('assets/stub.json');
      final List<dynamic> jsonData = json.decode(data);
      return jsonData.map((previsionJson) {
        return PrevisionA.fromJson1(previsionJson);
      }).toList();
    } catch (e) {
      throw Exception('Failed to load mock services: $e');
    }
  }

  Future<List<PrevisionA>> fetchPrevisionsV5() async {
    List<PrevisionA> previsionList = await apiService.fetchPrevisionsv5();
    return previsionList;
  }
}