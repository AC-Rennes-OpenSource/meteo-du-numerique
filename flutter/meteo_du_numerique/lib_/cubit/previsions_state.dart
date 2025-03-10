// État pour les prévisions
import 'package:equatable/equatable.dart';

import '../models/models.dart';

class PrevisionsState extends Equatable {
  final List<Prevision> allPrevisions;
  final List<Prevision> filteredPrevisions;
  final List<PrevisionGroup> groupedPrevisions;
  final Category? selectedCategory;
  final DateTime? startDate;
  final String searchQuery;

  const PrevisionsState({
    this.allPrevisions = const [],
    this.filteredPrevisions = const [],
    this.groupedPrevisions = const [],
    this.selectedCategory,
    this.startDate,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [allPrevisions, filteredPrevisions, groupedPrevisions, selectedCategory, startDate, searchQuery];

  PrevisionsState copyWith({
    List<Prevision>? allPrevisions,
    List<Prevision>? filteredPrevisions,
    List<PrevisionGroup>? groupedPrevisions,
    Category? selectedCategory,
    DateTime? startDate,
    String? searchQuery,
  }) {
    return PrevisionsState(
      allPrevisions: allPrevisions ?? this.allPrevisions,
      filteredPrevisions: filteredPrevisions ?? this.filteredPrevisions,
      groupedPrevisions: groupedPrevisions ?? this.groupedPrevisions,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      startDate: startDate ?? this.startDate,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
