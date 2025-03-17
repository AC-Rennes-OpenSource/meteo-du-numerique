abstract class ServicesNumEvent {}

class FetchServicesNumEvent extends ServicesNumEvent {
  final bool showIndicator;

  FetchServicesNumEvent({this.showIndicator = true});
}

class FilterServicesNumEvent extends ServicesNumEvent {
  final List<String>? filterBy;

  FilterServicesNumEvent(this.filterBy);
}

class SortServicesNumEvent extends ServicesNumEvent {
  final String? sortBy;
  final String? order;

  SortServicesNumEvent(this.sortBy, this.order);
}

class SearchItemsEvent extends ServicesNumEvent {
  final String? query;

  SearchItemsEvent(this.query);
}
