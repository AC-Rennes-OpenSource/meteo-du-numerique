import 'package:bloc/bloc.dart';

import '../models/models.dart';
import '../services/mock-api-service.dart';
import 'previsions_state.dart';

class PrevisionsCubit extends Cubit<PrevisionsState> {
  final MockApiService apiService;

  PrevisionsCubit(this.apiService) : super(PrevisionsState());

  Future<void> loadPrevisions() async {
    final previsions = await apiService.getPrevisions();
    emit(state.copyWith(allPrevisions: previsions, groupedPrevisions: _groupPrevisionsByMonth(previsions)));
    _applyFilters();
  }

  void setCategoryFilter(Category? category) {
    emit(state.copyWith(selectedCategory: category));
    _applyFilters();
  }

  void setStartDate(DateTime? date) {
    emit(state.copyWith(startDate: date));
    _applyFilters();
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    _applyFilters();
  }

  void toggleGroupExpansion(String groupKey) {
    final updatedGroups = state.groupedPrevisions.map((group) {
      if (group.dateDebut == groupKey) {
        return PrevisionGroup(
          dateDebut: group.dateDebut,
          previsions: group.previsions,
          isExpanded: !group.isExpanded,
        );
      }
      return group;
    }).toList();
    emit(state.copyWith(groupedPrevisions: updatedGroups));
  }

  void _applyFilters() {
    var filtered = state.allPrevisions;

    // Apply category filter
    if (state.selectedCategory != null) {
      filtered = filtered.where((p) => p.category?.id == state.selectedCategory!.id).toList();
    }

    // Apply start date filter
    if (state.startDate != null) {
      filtered = filtered.where((p) => p.dateDebut.isAfter(state.startDate!)).toList();
    }

    // Apply search query
    if (state.searchQuery.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.libelle.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
              p.description.toLowerCase().contains(state.searchQuery.toLowerCase()))
          .toList();
    }

    emit(state.copyWith(filteredPrevisions: filtered, groupedPrevisions: _groupPrevisionsByMonth(filtered)));
  }

  List<PrevisionGroup> _groupPrevisionsByMonth(List<Prevision> previsions) {
    final Map<String, List<Prevision>> grouped = {};

    // Grouper les prévisions par mois
    for (var prevision in previsions) {
      final key = "${prevision.dateDebut.year}-${prevision.dateDebut.month.toString().padLeft(2, '0')}";
      if (!grouped.containsKey(key)) grouped[key] = [];
      grouped[key]!.add(prevision);
    }

    // Créer de nouveaux groupes en préservant l'état d'expansion existant
    return grouped.entries.map((entry) {
      // Rechercher le groupe existant avec la même clé
      final existingGroup = state.groupedPrevisions.firstWhere((group) => group.dateDebut == entry.key,
          orElse: () => PrevisionGroup(dateDebut: entry.key, previsions: entry.value, isExpanded: false));

      // Créer un nouveau groupe avec les prévisions actualisées et l'état d'expansion conservé
      return PrevisionGroup(
        dateDebut: entry.key,
        previsions: entry.value,
        isExpanded: existingGroup.isExpanded,
      );
    }).toList();
  }
}
