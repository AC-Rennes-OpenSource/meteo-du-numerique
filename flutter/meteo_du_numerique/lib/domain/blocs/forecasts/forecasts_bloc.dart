import 'package:diacritic/diacritic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../data/models/forecast.dart';
import '../../../data/repositories/forecasts_repository.dart';
import 'forecasts_event.dart';
import 'forecasts_state.dart';

class ForecastsBloc extends Bloc<ForecastsEvent, ForecastsState> {
  final ForecastsRepository forecastsRepository;

  String? currentSortCriteria = 'startDate';
  String? currentSortOrder = 'asc';
  List<String>? currentFilterCriteria = [];
  String? currentSearchQuery;
  Map<int, Map<String, bool>> groupState = {};
  Map<int, Map<String, bool>> dayGroupState = {};
  bool enableForecastsGroups = true;
  String currentPeriode = 'all';

  List<String> currentFilters = [];

  ForecastsBloc({required this.forecastsRepository}) : super(ForecastsInitial()) {
    _initGroupState();

    on<FetchForecastsEvent>(_onFetchForecasts);
    on<FilterForecastsEvent>(_onFilterForecasts);
    on<SearchForecastsEvent>(_onSearchForecasts);
    on<ToggleForecastGroupEvent>(_onToggleGroup);
    on<ToggleDayForecastGroupEvent>(_onToggleDayGroup);
    on<OpenAllGroupsEvent>(_onOpenAllGroups);
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

  Future<void> _onFetchForecasts(FetchForecastsEvent event, Emitter<ForecastsState> emit) async {
    if (event.showIndicator) {
      emit(ForecastsLoading());
    }

    try {
      final forecasts = await _getForecasts();

      // Group forecasts by start date
      final Map<String, List<Forecast>> groupsByStartDate = _getGroupsByStartDate(forecasts);

      // Group forecasts by month
      final Map<String, List<Forecast>> groupsByMonth = _getGroupsByMonth(forecasts);

      emit(ForecastsLoaded(
        forecasts: forecasts,
        groupsByStartDate: groupsByStartDate,
        groupsByMonth: groupsByMonth,
      ));
    } catch (e) {
      emit(ForecastsError(message: e.toString()));
    }
  }

  void _onFilterForecasts(FilterForecastsEvent event, Emitter<ForecastsState> emit) {
    currentFilterCriteria = event.categories;
    currentPeriode = event.period;
    currentFilters = currentFilterCriteria!;
    add(const FetchForecastsEvent());
  }

  void _onSearchForecasts(SearchForecastsEvent event, Emitter<ForecastsState> emit) {
    currentSearchQuery = event.query;
    add(const FetchForecastsEvent());
  }

  void _onToggleGroup(ToggleForecastGroupEvent event, Emitter<ForecastsState> emit) {
    final month = event.month;
    final year = int.parse(event.year);
    _updateGroupState(month, year);
    add(const FetchForecastsEvent());
  }

  void _onToggleDayGroup(ToggleDayForecastGroupEvent event, Emitter<ForecastsState> emit) {
    if (state is ForecastsLoaded) {
      final currentState = state as ForecastsLoaded;

      emit(ForecastsLoaded(
        forecasts: currentState.forecasts,
        groupsByStartDate: currentState.groupsByStartDate,
        groupsByMonth: currentState.groupsByMonth,
        isDayPanelOpen: !currentState.isDayPanelOpen,
        expandedGroups: currentState.expandedGroups,
      ));
    }
  }

  void _onOpenAllGroups(OpenAllGroupsEvent event, Emitter<ForecastsState> emit) {
    if (state is ForecastsLoaded) {
      final currentState = state as ForecastsLoaded;
      final newExpandedGroups = <String, bool>{};

      // Set all groups to expanded
      for (final monthYear in currentState.groupsByMonth.keys) {
        newExpandedGroups[monthYear] = true;
      }

      emit(ForecastsLoaded(
        forecasts: currentState.forecasts,
        groupsByStartDate: currentState.groupsByStartDate,
        groupsByMonth: currentState.groupsByMonth,
        isDayPanelOpen: currentState.isDayPanelOpen,
        expandedGroups: newExpandedGroups,
      ));
    }
  }

  Future<List<Forecast>> _getForecasts() async {
    // Get forecasts from repository
    List<Forecast> forecasts = await forecastsRepository.getForecasts(useMock: false);

    // Apply search filter
    if (currentSearchQuery != null && currentSearchQuery!.isNotEmpty) {
      final normalizedQuery = removeDiacritics(currentSearchQuery!.toLowerCase());
      forecasts = forecasts
          .where((forecast) =>
              removeDiacritics(forecast.title?.toLowerCase() ?? '').contains(normalizedQuery) ||
              removeDiacritics(forecast.content?.toLowerCase() ?? '').contains(normalizedQuery) ||
              removeDiacritics(forecast.service?.name?.toLowerCase() ?? '').contains(normalizedQuery))
          .toList();
    }

    // Apply type filter
    if (currentFilterCriteria != null && currentFilterCriteria!.isNotEmpty) {
      List<Forecast> filteredForecasts = [];
      for (var typeId in currentFilterCriteria!) {
        filteredForecasts.addAll(forecasts.where((forecast) => forecast.service?.category?.id.toString() == typeId).toList());
      }
      forecasts = filteredForecasts;
    }

    final now = DateTime.now();

    // First, remove all forecasts with endDate before today
    forecasts = forecasts.where((forecast) {
      if (forecast.endDate == null) return true; // Keep forecasts with no endDate
      final endDate = DateTime.parse(forecast.endDate!);
      return endDate.isAfter(now) || endDate.isAtSameMomentAs(now);
    }).toList();

    // Apply period filter
    if (currentPeriode != 'all') {
      if (currentPeriode == 'today') {
        // Only today's forecasts
        forecasts = forecasts.where((forecast) {
          if (forecast.startDate == null) return false;
          final date = DateTime.parse(forecast.startDate!);
          return date.year == now.year && date.month == now.month && date.day == now.day;
        }).toList();
      } else if (currentPeriode == 'week') {
        // This week's forecasts
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));

        forecasts = forecasts.where((forecast) {
          if (forecast.startDate == null) return false;
          final date = DateTime.parse(forecast.startDate!);
          return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) && date.isBefore(endOfWeek.add(const Duration(days: 1)));
        }).toList();
      } else if (currentPeriode == 'month') {
        // This month's forecasts
        forecasts = forecasts.where((forecast) {
          if (forecast.startDate == null) return false;
          final date = DateTime.parse(forecast.startDate!);
          return date.year == now.year && date.month == now.month;
        }).toList();
      }
    }

    return forecasts;
  }

  Map<String, List<Forecast>> _getGroupsByStartDate(List<Forecast> forecasts) {
    Map<String, List<Forecast>> groupedLists = {};

    // Filter by enabled days
    if (enableForecastsGroups) {
      for (Forecast forecast in forecasts) {
        if (forecast.startDate == null) continue;

        // Find which group this belongs to
        final date = DateTime.parse(forecast.startDate!);
        final dateStr = DateFormat('yyyy-MM-dd').format(date);

        if (groupedLists.containsKey(dateStr)) {
          groupedLists[dateStr]!.add(forecast);
        } else {
          groupedLists[dateStr] = [forecast];
        }
      }
    } else {
      // Just one big list
      groupedLists = {'All forecasts': forecasts};
    }

    return groupedLists;
  }

  Map<String, List<Forecast>> _getGroupsByMonth(List<Forecast> forecasts) {
    Map<String, List<Forecast>> groupedLists = {};

    // Format for month + year (we'll sort this later)
    for (Forecast forecast in forecasts) {
      if (forecast.startDate == null) continue;

      // Only include if the day group is enabled
      final date = DateTime.parse(forecast.startDate!);
      final String monthYearText = DateFormat('MMM yyyy').format(date);

      if (groupState[date.year]?[date.month.toString()] == true) {
        // Include this item
        if (groupedLists.containsKey(monthYearText)) {
          groupedLists[monthYearText]!.add(forecast);
        } else {
          groupedLists[monthYearText] = [forecast];
        }
      }
    }

    // Sort the groups by date
    var sortedKeys = groupedLists.keys.toList()
      ..sort((a, b) {
        // Extract month/year from string
        DateTime dateA = DateFormat('MMM yyyy').parse(a);
        DateTime dateB = DateFormat('MMM yyyy').parse(b);
        return dateA.compareTo(dateB);
      });

    // Create a new ordered map
    Map<String, List<Forecast>> sortedGroups = {};
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
}
