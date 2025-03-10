import 'package:equatable/equatable.dart';
import '../models/models.dart';

// État pour les services numériques
class ServicesNumeriquesState extends Equatable {
  final List<ServiceNumerique> allServices;
  final List<ServiceNumerique> filteredServices;
  final QualiteDeService? selectedQoS;
  final String searchQuery;
  final bool sortByState;
  final bool sortByName;

  const ServicesNumeriquesState({
    this.allServices = const [],
    this.filteredServices = const [],
    this.selectedQoS,
    this.searchQuery = '',
    this.sortByState = false,
    this.sortByName = false,
  });

  @override
  List<Object?> get props => [allServices, filteredServices, selectedQoS, searchQuery, sortByState, sortByName];

  ServicesNumeriquesState copyWith({
    List<ServiceNumerique>? allServices,
    List<ServiceNumerique>? filteredServices,
    QualiteDeService? selectedQoS,
    String? searchQuery,
    bool? sortByState,
    bool? sortByName,
  }) {
    return ServicesNumeriquesState(
      allServices: allServices ?? this.allServices,
      filteredServices: filteredServices ?? this.filteredServices,
      selectedQoS: selectedQoS ?? this.selectedQoS,
      searchQuery: searchQuery ?? this.searchQuery,
      sortByState: sortByState ?? this.sortByState,
      sortByName: sortByName ?? this.sortByName,
    );
  }
}


