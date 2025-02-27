import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';

import '../../models/service_num_model.dart';
import '../../services/api_service.dart';
import '../../utils.dart';
import 'previsions_event.dart';
import 'previsions_state.dart';

class PrevisionsBloc extends Bloc<PrevisionsEvent, PrevisionsState> {
  final ApiService apiService;
  final bool useMockData;

  bool isPanelOpen = true;

  String? currentSortCriteria = 'qualiteDeServiceId';
  String? currentSortOrder = 'desc';
  List<String> currentFilterCriteria = [];
  String currentPeriode = 'all';
  String? currentSearchQuery;

  late DateTime? lastUpdate = DateTime.now();

  List<String> currentFilters = [];
  Map<String, bool> expandedGroups = {}; // Pour conserver l'état d'expansion des groupes

  PrevisionsBloc({required this.apiService, this.useMockData = true}) : super(PrevisionsInitial()) {
    on<FetchPrevisionsEvent>(_onFetchPrevisions);
    on<FilterPrevisionsEvent>(_onFilterPrevisions);
    on<SortPrevisionsEvent>(_onSortPrevisions);
    on<SearchPrevisionsEvent>(_onSearchPrevisions);
    on<TogglePrevisionGroupEvent>(_onTogglePrevisionGroup);
    on<ToggleDayPrevisionGroupEvent>(_onToggleDayPrevisionGroup);
    on<OpenAllGroupsEvent>(_onOpenAllGroups);
    on<AddCategoryEvent>(_onAddCategoryEvent);
    on<RemoveCategoryEvent>(_onRemoveCategoryEvent);
  }

  Future<void> _onFetchPrevisions(FetchPrevisionsEvent event, Emitter<PrevisionsState> emit) async {
    print("_onFetchPrevisions__________________________");

    if (event.showIndicator) {
      emit(PrevisionsLoading());
    }

    // TODO : délai pour test
    // await Future.delayed(const Duration(milliseconds: 1500));

    try {
      final previsions = await _getPrevisions();
      final dayPrevisions = previsions.where((objet) {
        return Utils.estMemeJour(objet.dateDebut, DateTime.now().subtract(const Duration(days: 0)));
      }).toList();
      final groupedPrevisions = _groupPrevisionsByMonthAndYear(previsions);

      // Initialise tous les groupes comme étant ouverts
      final expandedGroups = {for (var k in groupedPrevisions.keys) k: true};

      emit(PrevisionsLoaded(
          isDayPanelOpen: isPanelOpen, previsionsGroupedByMonth: groupedPrevisions, expandedGroups: expandedGroups, dayPrevisions: dayPrevisions));
    } catch (e) {
      emit(PrevisionsError(message: e.toString()));
    }
  }

  Map<String, List<PrevisionA>> _groupPrevisionsByMonthAndYear(List<PrevisionA> previsions) {
    Map<String, List<PrevisionA>> grouped = {};
    for (var prevision in previsions) {
      DateTime date = prevision.dateDebut;
      String key = '${date.year}${date.month.toString().padLeft(2, '0')}'; // Format "YYYYMM"

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(prevision);
    }
    return grouped;
  }

  void _onAddCategoryEvent(AddCategoryEvent event, Emitter<PrevisionsState> emit) {
    final currentState = state;
    if (currentState is PrevisionsLoaded) {
      final Map<String, bool> expandedGroups = Map.from(currentState.expandedGroups)..updateAll((key, value) => true);

      emit(PrevisionsLoaded(
          previsionsGroupedByMonth: currentState.previsionsGroupedByMonth,
          expandedGroups: expandedGroups,
          isDayPanelOpen: currentState.isDayPanelOpen,
          dayPrevisions: currentState.dayPrevisions));
    }
  }

  void _onRemoveCategoryEvent(RemoveCategoryEvent event, Emitter<PrevisionsState> emit) {
    final currentState = state;
    if (currentState is PrevisionsLoaded) {
      final Map<String, bool> expandedGroups = Map.from(currentState.expandedGroups)
        ..updateAll((key, value) => true); // Mettre à jour tous les états d'expansion sur true

      emit(PrevisionsLoaded(
          previsionsGroupedByMonth: currentState.previsionsGroupedByMonth,
          expandedGroups: expandedGroups,
          isDayPanelOpen: currentState.isDayPanelOpen,
          dayPrevisions: currentState.dayPrevisions));
    }
  }

  void _onOpenAllGroups(OpenAllGroupsEvent event, Emitter<PrevisionsState> emit) {
    final currentState = state;
    if (currentState is PrevisionsLoaded) {
      final Map<String, bool> expandedGroups = Map.from(currentState.expandedGroups)..updateAll((key, value) => true);
      emit(PrevisionsLoaded(
          previsionsGroupedByMonth: currentState.previsionsGroupedByMonth,
          expandedGroups: expandedGroups,
          isDayPanelOpen: currentState.isDayPanelOpen,
          dayPrevisions: currentState.dayPrevisions));
    }
  }

  void _onTogglePrevisionGroup(TogglePrevisionGroupEvent event, Emitter<PrevisionsState> emit) {
    final currentState = state;
    if (currentState is PrevisionsLoaded) {
      String yearMonthKey = event.year + event.month.padLeft(2, '0');

      // Clone l'état actuel des groupes expandus
      final Map<String, bool> expandedGroups = Map<String, bool>.from(currentState.expandedGroups);

      // Bascule l'état d'expansion pour le groupe spécifié
      expandedGroups[yearMonthKey] = !(expandedGroups[yearMonthKey] ?? false);

      emit(PrevisionsLoaded(
          previsionsGroupedByMonth: currentState.previsionsGroupedByMonth,
          expandedGroups: expandedGroups,
          isDayPanelOpen: currentState.isDayPanelOpen,
          dayPrevisions: currentState.dayPrevisions));
    }
  }

  void _onToggleDayPrevisionGroup(ToggleDayPrevisionGroupEvent event, Emitter<PrevisionsState> emit) async {
    final currentState = state;
    isPanelOpen = !isPanelOpen; // Basculez l'état de isPanelOpen
    if (currentState is PrevisionsLoaded) {
      emit(PrevisionsLoaded(
          previsionsGroupedByMonth: currentState.previsionsGroupedByMonth,
          expandedGroups: currentState.expandedGroups,
          isDayPanelOpen: isPanelOpen,
          dayPrevisions: currentState.dayPrevisions));
    }
  }

  void _onFilterPrevisions(FilterPrevisionsEvent event, Emitter<PrevisionsState> emit) async {
    if (event.categories == []) {
      resetCriteria();
      currentFilters = [];
      currentPeriode = 'all';
    } else {
      currentFilterCriteria = event.categories;
      currentFilters = currentFilterCriteria;
      currentPeriode = event.periode;
    }
    add(FetchPrevisionsEvent());
  }

  void _onSortPrevisions(SortPrevisionsEvent event, Emitter<PrevisionsState> emit) async {
    // resetCriteria();
    currentSortCriteria = event.sortBy;
    currentSortOrder = event.order;
    add(FetchPrevisionsEvent());
  }

  void _onSearchPrevisions(SearchPrevisionsEvent event, Emitter<PrevisionsState> emit) async {
    // resetCriteria();
    currentSearchQuery = event.query;
    add(FetchPrevisionsEvent());
  }

  void resetCriteria() {
    currentSortCriteria = null;
    currentFilterCriteria = [];
    currentPeriode = 'all';
    currentSearchQuery = null;
    add(FetchPrevisionsEvent());
  }

  Future<List<PrevisionA>> _getPrevisions() async {



    List<PrevisionA> previsionList = await fetchPrevisionsV5();

    // previsionList = await apiService.fetchPrevisions();
    //
    //
    // // TODO mock/stub
    // previsionList = await apiService.fetchMockPrevisions();
    //

    // filtre les prévisions passées todo est ce nécessaire?
    previsionList.removeWhere((prev) => !prev.dateDebut.isAfter(DateTime.now()));

    // // Apply search filter
    if (currentSearchQuery != null && currentSearchQuery!.isNotEmpty) {
      previsionList = previsionList
      // todo
          .where((prevision) => Utils.normalizeText(prevision.libelle.toLowerCase())
              .contains(Utils.normalizeText(currentSearchQuery!.toLowerCase())))
          .toList();
    }
    //
    // // Apply category filter
    if (currentFilterCriteria.isNotEmpty) {
      // print(currentFilterCriteria);
      List<PrevisionA> previsionsupdate = [];
      for (var element in currentFilterCriteria) {
        previsionsupdate.addAll(previsionList
            .where((prevision) => prevision.categorieLibelle.toLowerCase() == element.toLowerCase())
            .toList());
      }
      previsionList = previsionsupdate;
    }



    // Apply perio filter
    if (currentPeriode != 'all') {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day - 1);

      if (currentPeriode == 'semaine') {
        previsionList = previsionList.where((prevision) {
          return prevision.dateDebut.isAfter(today) &&
              prevision.dateDebut.isBefore(DateTime(now.year, now.month, now.day + 7));
        }).toList();
      } else if (currentPeriode == 'mois') {
        previsionList = previsionList.where((prevision) {
          return prevision.dateDebut.isAfter(today) && prevision.dateDebut.isBefore(DateTime(now.year, now.month + 2));
        }).toList();
      } else if (currentPeriode == 'semestre') {
        previsionList = previsionList.where((prevision) {
          return prevision.dateDebut.isAfter(today) &&
              prevision.dateDebut.isBefore(DateTime(now.year, now.month + now.day + 180));
        }).toList();
      }
    }

    return previsionList;
    // return await fetchMockPrevisions();
    // return await fetchPrevisionsV5();
  }

  List<PrevisionA> generateMockPrevisions(int count) {
    final List<String> categories = ['Météo', 'Sport', 'Culture', 'Éducation'];
    final List<String> colors = ['rose', 'bleu', 'jaune', 'orange', 'vert'];

    return List.generate(count, (index) {
      final randomCategory = categories[index % categories.length];
      final randomColor = colors[index % colors.length];

      return PrevisionA(
        id: (index + 1).toString(),
        libelle: 'Prévision $index',
        description: 'Description de la prévision $index',
        dateDebut: DateTime.now().add(Duration(days: index * 2)),
        dateFin: DateTime.now().add(Duration(days: index * 5)),
        categorieLibelle: randomCategory,
        couleur: randomColor,
      );
    });
  }

  Future<List<PrevisionA>> fetchMockPrevisions() async {
    // Charger le fichier JSON depuis les assets
    try {
      String data = await rootBundle.loadString('assets/strapi5mock.json');

      final Map<String, dynamic> parsedJson = json.decode(data);
      // Convertir les données en objets PrevisionA
      return (parsedJson['previsions'] as List<dynamic>).map((previsionJson) {
        return PrevisionA.fromJson1(previsionJson);
      }).toList();
    } catch (e) {
      print(e);

      throw Exception('Failed to load mock services: $e');
    }
  }

  Future<List<PrevisionA>> fetchPrevisionsV5() async {
    print("fetchPrevisionsV5 ______");
    List<PrevisionA> previsionList = await apiService.fetchPrevisionsv5();
return previsionList;
    print("log : fetchMockPrevisions triggered");
    // Charger le fichier JSON depuis les assets
    try {
      String data = await rootBundle.loadString('assets/strapi5mock.json');

      final Map<String, dynamic> parsedJson = json.decode(data);
print("date : $data");
      // Convertir les données en objets PrevisionA
      return (parsedJson['previsions'] as List<dynamic>).map((previsionJson) {
        return PrevisionA.fromJson1(previsionJson);
      }).toList();
    } catch (e) {
      print(e);

      throw Exception('Failed to load mock services: $e');
    }
  }
}
