import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';


class AppCubit extends Cubit<AppState> {
  TabController? tabController;

  AppCubit([this.tabController]) : super(AppState(tabIndex: 0, isFeatureEnabled: false));

  void changeTab(int index) {
    // todo
    // tabController?.animateTo(index);
    print(index);
    emit(state.copyWith(tabIndex: index));
  }

  void setTabController(TabController controller) {
    tabController = controller;
  }

  void toggleFeature(bool isEnabled) {
    emit(state.copyWith(isFeatureEnabled: isEnabled));
  }
}

class AppState {
  final int tabIndex;
  final bool isFeatureEnabled;

  AppState({
    required this.tabIndex,
    required this.isFeatureEnabled,
  });

  AppState copyWith({
    int? tabIndex,
    bool? isFeatureEnabled,
  }) {
    return AppState(
      tabIndex: tabIndex ?? this.tabIndex,
      isFeatureEnabled: isFeatureEnabled ?? this.isFeatureEnabled,
    );
  }
}