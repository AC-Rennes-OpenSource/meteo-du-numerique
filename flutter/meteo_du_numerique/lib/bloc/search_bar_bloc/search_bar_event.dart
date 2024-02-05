abstract class SearchBarEvent {}

class OpenSearchBar extends SearchBarEvent {}

class CloseSearchBar extends SearchBarEvent {}

class UpdateSearchQuery extends SearchBarEvent {
  final String query;

  UpdateSearchQuery(this.query);
}
