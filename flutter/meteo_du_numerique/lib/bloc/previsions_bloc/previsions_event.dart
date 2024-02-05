abstract class PrevisionsEvent {}

class FetchPrevisionsEvent extends PrevisionsEvent {
  final bool showIndicator;

  FetchPrevisionsEvent({this.showIndicator = true});
}

class FilterPrevisionsEvent extends PrevisionsEvent {
  final List<String>? filterBy;

  FilterPrevisionsEvent(this.filterBy);
}

class SortPrevisionsEvent extends PrevisionsEvent {
  final String? sortBy;
  final String? order;

  SortPrevisionsEvent(this.sortBy, this.order);
}

class SearchPrevisionsEvent extends PrevisionsEvent {
  final String? query;

  SearchPrevisionsEvent(this.query);
}

// Evénement pour gérer le toggle des accordéons
class TogglePrevisionGroupEvent extends PrevisionsEvent {
  final String month;
  final String year;

  TogglePrevisionGroupEvent({required this.month, required this.year});
}

class ToggleDayPrevisionGroupEvent extends PrevisionsEvent {}

class OpenAllGroupsEvent extends PrevisionsEvent {}

class AddCategoryEvent extends PrevisionsEvent {}

class RemoveCategoryEvent extends PrevisionsEvent {}
