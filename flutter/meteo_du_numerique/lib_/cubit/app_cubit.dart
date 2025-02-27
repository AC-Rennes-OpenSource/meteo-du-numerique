import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class AppCubit extends Cubit<int> {
  TabController? tabController;

  AppCubit([this.tabController]) : super(0);

  void changeTab(int index) {
    tabController?.animateTo(index);
    print(index);
    emit(index);
  }

  void setTabController(TabController controller) {
    tabController = controller;
  }
}