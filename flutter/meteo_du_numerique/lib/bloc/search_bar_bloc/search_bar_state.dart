abstract class SearchBarState {}

class SearchBarOpened extends SearchBarState {}

class SearchBarClosed extends SearchBarState {}

class SearchBarQueryUpdated extends SearchBarState {
  final String query;

  SearchBarQueryUpdated(this.query);
}
