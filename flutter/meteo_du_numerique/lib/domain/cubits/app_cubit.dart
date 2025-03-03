import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppState extends Equatable {
  final int tabIndex;
  final bool isBetaEnabled;

  const AppState({
    required this.tabIndex,
    required this.isBetaEnabled,
  });

  AppState copyWith({
    int? tabIndex,
    bool? isBetaEnabled,
  }) {
    return AppState(
      tabIndex: tabIndex ?? this.tabIndex,
      isBetaEnabled: isBetaEnabled ?? this.isBetaEnabled,
    );
  }
  
  @override
  List<Object> get props => [tabIndex, isBetaEnabled];
}

class AppCubit extends Cubit<AppState> {
  TabController? tabController;

  AppCubit([this.tabController]) : super(const AppState(tabIndex: 0, isBetaEnabled: false));

  void changeTab(int index) {
    emit(state.copyWith(tabIndex: index));
  }

  void setTabController(TabController controller) {
    tabController = controller;
  }

  void toggleBetaFeature(bool isEnabled) {
    emit(state.copyWith(isBetaEnabled: isEnabled));
  }
}