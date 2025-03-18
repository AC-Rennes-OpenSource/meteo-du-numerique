import 'package:flutter/widgets.dart';

import '../../models/actualite_model.dart';

abstract class ServicesNumState extends ChangeNotifier {}

class ServicesNumInitial extends ServicesNumState {}

class ServicesNumLoading extends ServicesNumState {}

class ServicesNumLoaded extends ServicesNumState {
  final List<Actualite> servicesList;
  final DateTime? lastUpdate;

  ServicesNumLoaded({required this.servicesList, this.lastUpdate});
}

class ServicesNumError extends ServicesNumState {
  final String message;

  ServicesNumError({required this.message});
}

class ServicesNumFiltered extends ServicesNumState {
  final bool showBadge;

  ServicesNumFiltered({this.showBadge = false});

  ServicesNumState copyWith({bool? showBadge}) {
    return ServicesNumFiltered(
      showBadge: showBadge ?? this.showBadge,
    );
  }
}
