class ActualiteState {}

class ActualiteInitial extends ActualiteState {}

class ActualiteLoading extends ActualiteState {}

class ActualitesLoaded extends ActualiteState {
  final List<dynamic> actualitesList;
  final DateTime? lastUpdate;

  ActualitesLoaded({required this.actualitesList, this.lastUpdate});
}

class ActualiteError extends ActualiteState {
  final String message;

  ActualiteError({required this.message});
}

class ActualiteFiltered extends ActualiteState {
  final bool showBadge;

  ActualiteFiltered({required this.showBadge});
}
