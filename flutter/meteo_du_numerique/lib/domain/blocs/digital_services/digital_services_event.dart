import 'package:equatable/equatable.dart';

abstract class DigitalServicesEvent extends Equatable {
  const DigitalServicesEvent();

  @override
  List<Object?> get props => [];
}

class FetchDigitalServicesEvent extends DigitalServicesEvent {
  final bool showIndicator;

  const FetchDigitalServicesEvent({this.showIndicator = true});

  @override
  List<Object> get props => [showIndicator];
}

class SearchDigitalServicesEvent extends DigitalServicesEvent {
  final String? query;

  const SearchDigitalServicesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterDigitalServicesEvent extends DigitalServicesEvent {
  final List<String>? categories;

  const FilterDigitalServicesEvent(this.categories);

  @override
  List<Object?> get props => [categories];
}

class SortDigitalServicesEvent extends DigitalServicesEvent {
  final String? sortBy;
  final String? order;

  const SortDigitalServicesEvent(this.sortBy, this.order);

  @override
  List<Object?> get props => [sortBy, order];
}

class RefreshDigitalServicesEvent extends DigitalServicesEvent {}