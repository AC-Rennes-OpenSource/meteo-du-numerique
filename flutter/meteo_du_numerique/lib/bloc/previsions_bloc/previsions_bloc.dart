import 'package:bloc/bloc.dart';

import '../../models/prevision_model.dart';
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
    if (event.showIndicator) {
      emit(PrevisionsLoading());
    }

    try {
      final previsions = await _getPrevisions();
      final dayPrevisions = previsions.where((objet) {
        return Utils.isSameDay(objet.dateDebut, DateTime.now().subtract(const Duration(days: 0)));
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

  Map<String, List<Prevision>> _groupPrevisionsByMonthAndYear(List<Prevision> previsions) {
    Map<String, List<Prevision>> grouped = {};
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

  Future<List<Prevision>> _getPrevisions() async {
    List<Prevision> previsionList = await fetchPrevisionsV5();

    // filtre les prévisions passées
    previsionList.removeWhere((prev) => !prev.dateDebut.isAfter(DateTime.now()));

    // // Apply search filter
    if (currentSearchQuery != null && currentSearchQuery!.isNotEmpty) {
      previsionList = previsionList
          .where((prevision) => Utils.normalizeText(prevision.libelle.toLowerCase()).contains(Utils.normalizeText(currentSearchQuery!.toLowerCase())))
          .toList();
    }

    // Apply category filter
    if (currentFilterCriteria.isNotEmpty) {
      List<Prevision> previsionsupdate = [];
      for (var element in currentFilterCriteria) {
        previsionsupdate.addAll(previsionList.where((prevision) => prevision.categorieLibelle.toLowerCase() == element.toLowerCase()).toList());
      }
      previsionList = previsionsupdate;
    }

    // Apply perio filter
    if (currentPeriode != 'all') {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day - 1);

      if (currentPeriode == 'semaine') {
        previsionList = previsionList.where((prevision) {
          return prevision.dateDebut.isAfter(today) && prevision.dateDebut.isBefore(DateTime(now.year, now.month, now.day + 7));
        }).toList();
      } else if (currentPeriode == 'mois') {
        previsionList = previsionList.where((prevision) {
          return prevision.dateDebut.isAfter(today) && prevision.dateDebut.isBefore(DateTime(now.year, now.month + 2));
        }).toList();
      } else if (currentPeriode == 'semestre') {
        previsionList = previsionList.where((prevision) {
          return prevision.dateDebut.isAfter(today) && prevision.dateDebut.isBefore(DateTime(now.year, now.month + now.day + 180));
        }).toList();
      }
    }

    return previsionList;
  }

  Future<List<Prevision>> fetchPrevisionsV5() async {
    List<Prevision> previsionList = await apiService.fetchPrevisionsv5();
    return previsionList;
  }
}
