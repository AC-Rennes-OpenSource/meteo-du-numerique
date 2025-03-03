import 'package:flutter_bloc/flutter_bloc.dart';

import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchClosed()) {
    on<OpenSearchBar>((event, emit) {
      emit(SearchOpened());
    });

    on<CloseSearchBar>((event, emit) {
      emit(SearchClosed());
    });

    on<UpdateSearchQuery>((event, emit) {
      emit(SearchQueryUpdated(event.query));
    });

    on<ClearAllEvent>((event, emit) {
      emit(ClearedAll());
      add(const UpdateSearchQuery(''));
      add(CloseSearchBar());
    });
  }
}