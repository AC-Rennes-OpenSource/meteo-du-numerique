import 'package:flutter/widgets.dart';

import '../../models/service_num_model.dart';
import '../../models/service_num_model_old.dart';

abstract class ServicesNumState extends ChangeNotifier {}

class ServicesNumInitial extends ServicesNumState {}

class ServicesNumLoading extends ServicesNumState {}

class ServicesNumLoaded extends ServicesNumState {
  final List<ActualiteA> servicesList;

  ServicesNumLoaded({required this.servicesList});
}

class ServicesNumError extends ServicesNumState {
  final String message;

  ServicesNumError({required this.message});
}

class ServicesNumSorted extends ServicesNumState {
  final String sortBy;
  final List<ServiceNumOld> sortedItems;

  ServicesNumSorted(this.sortBy, this.sortedItems);
}

class ServicesNumFiltered extends ServicesNumState {
  final bool showBadge;

  // final String? filter;
  // final List<ServiceNumOld>? filteredItems;

  ServicesNumFiltered({this.showBadge = false}
      // this.filter, this.filteredItems
      );

  ServicesNumState copyWith({bool? showBadge}) {
    return ServicesNumFiltered(
      showBadge: showBadge ?? this.showBadge,
    );
  }
}
