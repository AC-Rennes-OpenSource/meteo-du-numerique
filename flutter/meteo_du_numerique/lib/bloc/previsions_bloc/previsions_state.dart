import '../../models/prevision_model.dart';

abstract class PrevisionsState {}

class PrevisionsInitial extends PrevisionsState {}

class PrevisionsLoading extends PrevisionsState {}

class PrevisionsLoaded extends PrevisionsState {
  final Map<String, List<Prevision>> previsionsGroupedByMonth;
  final List<Prevision> dayPrevisions;
  final Map<String, bool> expandedGroups;

  final bool isDayPanelOpen;

  PrevisionsLoaded({
    required this.previsionsGroupedByMonth,
    required this.dayPrevisions,
    required this.isDayPanelOpen,
    required this.expandedGroups,
  });
}

class PrevisionsError extends PrevisionsState {
  final String message;

  PrevisionsError({required this.message});
}

class PrevisionsSorted extends PrevisionsState {
  final String sortBy;
  final List<Prevision> sortedPrevisions;

  PrevisionsSorted(this.sortBy, this.sortedPrevisions);
}

class PrevisionsFiltered extends PrevisionsState {
  final String filter;
  final List<Prevision> filteredPrevisions;

  PrevisionsFiltered(this.filter, this.filteredPrevisions);
}

class DayPrevisionsState extends PrevisionsState {
  final bool isPanelOpen;

  DayPrevisionsState({required this.isPanelOpen});
}
