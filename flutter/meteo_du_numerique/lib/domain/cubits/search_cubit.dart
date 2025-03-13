import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchClosed());

  void openSearchBar() {
    emit(SearchOpened());
  }

  void closeSearchBar() {
    emit(SearchClosed());
  }

  void updateSearchQuery(String query) {
    emit(SearchQueryUpdated(query));
  }

  void clearAll() {
    emit(ClearedAll());
    updateSearchQuery('');
    closeSearchBar();
  }
}
