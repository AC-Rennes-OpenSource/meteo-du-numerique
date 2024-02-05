abstract class ItemsEvent {}

class FetchItemsEvent extends ItemsEvent {
  final bool showIndicator;

  FetchItemsEvent({this.showIndicator = true});
}

class FilterItemsEvent extends ItemsEvent {
  final List<String>? filterBy;

  FilterItemsEvent(this.filterBy);
}

class SortItemsEvent extends ItemsEvent {
  final String? sortBy;
  final String? order;

  SortItemsEvent(this.sortBy, this.order);
}

class SearchItemsEvent extends ItemsEvent {
  final String? query;

  SearchItemsEvent(this.query);
}
