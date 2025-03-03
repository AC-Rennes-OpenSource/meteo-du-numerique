import 'package:equatable/equatable.dart';

import '../../../data/models/forecast.dart';

abstract class ForecastsState extends Equatable {
  const ForecastsState();
  
  @override
  List<Object?> get props => [];
}

class ForecastsInitial extends ForecastsState {}

class ForecastsLoading extends ForecastsState {}

class ForecastsLoaded extends ForecastsState {
  final List<Forecast> forecasts;
  final Map<String, List<Forecast>> groupsByStartDate;
  final Map<String, List<Forecast>> groupsByMonth;
  
  // Fields needed by ExpansionList
  final Map<String, List<Forecast>> dayForecasts;
  final Map<String, List<Forecast>> forecastsGroupedByMonth;
  final bool isDayPanelOpen;
  final Map<String, bool> expandedGroups;

  const ForecastsLoaded({
    required this.forecasts,
    required this.groupsByStartDate,
    required this.groupsByMonth,
    Map<String, List<Forecast>>? dayForecasts,
    Map<String, List<Forecast>>? forecastsGroupedByMonth,
    this.isDayPanelOpen = false,
    Map<String, bool>? expandedGroups,
  }) : 
    dayForecasts = dayForecasts ?? const {},
    forecastsGroupedByMonth = forecastsGroupedByMonth ?? const {},
    expandedGroups = expandedGroups ?? const {};
  
  @override
  List<Object?> get props => [forecasts, isDayPanelOpen, expandedGroups];
}

class ForecastsError extends ForecastsState {
  final String message;

  const ForecastsError({required this.message});
  
  @override
  List<Object> get props => [message];
}

class DayForecastsState extends ForecastsState {
  final bool isPanelOpen;

  const DayForecastsState({required this.isPanelOpen});
  
  @override
  List<Object> get props => [isPanelOpen];
}