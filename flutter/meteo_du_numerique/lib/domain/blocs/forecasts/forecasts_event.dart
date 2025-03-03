import 'package:equatable/equatable.dart';

abstract class ForecastsEvent extends Equatable {
  const ForecastsEvent();

  @override
  List<Object?> get props => [];
}

class FetchForecastsEvent extends ForecastsEvent {
  final bool showIndicator;

  const FetchForecastsEvent({this.showIndicator = true});

  @override
  List<Object> get props => [showIndicator];
}

class SearchForecastsEvent extends ForecastsEvent {
  final String? query;

  const SearchForecastsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterForecastsEvent extends ForecastsEvent {
  final List<String> categories;
  final String period;

  const FilterForecastsEvent(this.categories, this.period);

  @override
  List<Object> get props => [categories, period];
}

class SortForecastsEvent extends ForecastsEvent {
  final String? sortBy;
  final String? order;

  const SortForecastsEvent(this.sortBy, this.order);

  @override
  List<Object?> get props => [sortBy, order];
}

class ToggleForecastGroupEvent extends ForecastsEvent {
  final String month;
  final String year;

  const ToggleForecastGroupEvent({required this.month, required this.year});

  @override
  List<Object> get props => [month, year];
}

class ToggleDayForecastGroupEvent extends ForecastsEvent {}

class OpenAllGroupsEvent extends ForecastsEvent {}

class RefreshForecastsEvent extends ForecastsEvent {}

