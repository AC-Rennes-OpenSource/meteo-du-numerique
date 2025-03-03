import '../../models/service_num_model.dart';

abstract class PrevisionsState {}

class PrevisionsInitial extends PrevisionsState {}

class PrevisionsLoading extends PrevisionsState {}

class PrevisionsLoaded extends PrevisionsState {
  final List<PrevisionA> servicesList;
  final Map<String, List<PrevisionA>> groupsByDateDebut;
  final Map<String, List<PrevisionA>> groupsByMonth;
  
  // Fields needed by ExpansionList
  final Map<String, List<PrevisionA>> dayPrevisions;
  final Map<String, List<PrevisionA>> previsionsGroupedByMonth;
  final bool isDayPanelOpen;
  final Map<String, bool> expandedGroups;

  PrevisionsLoaded({
    required this.servicesList,
    required this.groupsByDateDebut,
    required this.groupsByMonth,
    Map<String, List<PrevisionA>>? dayPrevisions,
    Map<String, List<PrevisionA>>? previsionsGroupedByMonth,
    this.isDayPanelOpen = false,
    Map<String, bool>? expandedGroups,
  }) : 
    dayPrevisions = dayPrevisions ?? groupsByDateDebut,
    previsionsGroupedByMonth = previsionsGroupedByMonth ?? groupsByMonth,
    expandedGroups = expandedGroups ?? {};
}

class PrevisionsError extends PrevisionsState {
  final String message;

  PrevisionsError({required this.message});
}

class PrevisionsSorted extends PrevisionsState {
  final String sortBy;

  PrevisionsSorted(this.sortBy);
}

class PrevisionsFiltered extends PrevisionsState {
  PrevisionsFiltered();
}

class DayPrevisionsState extends PrevisionsState {
  final bool isPanelOpen;

  DayPrevisionsState({required this.isPanelOpen});
}