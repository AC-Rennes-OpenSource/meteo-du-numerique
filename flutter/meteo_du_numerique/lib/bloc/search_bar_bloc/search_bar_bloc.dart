import 'package:flutter_bloc/flutter_bloc.dart';

import 'search_bar_event.dart';
import 'search_bar_state.dart';

class SearchBarBloc extends Bloc<SearchBarEvent, SearchBarState> {
  SearchBarBloc() : super(SearchBarClosed()) {
    on<OpenSearchBar>((event, emit) {
      emit(SearchBarOpened());
    });

    on<CloseSearchBar>((event, emit) {
      emit(SearchBarClosed());
    });

    on<UpdateSearchQuery>((event, emit) {
      emit(SearchBarQueryUpdated(event.query));
    });

    on<ClearAllEvent>((event, emit) {
      UpdateSearchQuery('');
      CloseSearchBar();


      emit(ClearedAll());
    });
  }
}
