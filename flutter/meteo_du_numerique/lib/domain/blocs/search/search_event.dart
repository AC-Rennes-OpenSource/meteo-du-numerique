import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class OpenSearchBar extends SearchEvent {}

class CloseSearchBar extends SearchEvent {}

class UpdateSearchQuery extends SearchEvent {
  final String query;

  const UpdateSearchQuery(this.query);

  @override
  List<Object> get props => [query];
}

class ClearAllEvent extends SearchEvent {}