import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchOpened extends SearchState {}

class SearchClosed extends SearchState {}

class ClearedAll extends SearchState {}

class SearchQueryUpdated extends SearchState {
  final String query;

  const SearchQueryUpdated(this.query);

  @override
  List<Object> get props => [query];
}