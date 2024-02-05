// tab_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import 'tab_event.dart';
import 'tab_state.dart';

class TabBloc extends Bloc<TabEvent, TabState> {
  TabBloc() : super(TabState(currentIndex: 0)) {
    on<TabEvent>((event, emit) {
      emit(TabState(currentIndex: event.index));
    });
  }
}
