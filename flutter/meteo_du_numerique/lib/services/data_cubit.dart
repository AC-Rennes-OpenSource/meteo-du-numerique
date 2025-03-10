import 'package:bloc/bloc.dart';
import 'package:meteo_du_numerique/services/api_strapi_service.dart';

import 'models.dart';

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  final ApiStrapiService apiService;

  DataCubit({required this.apiService})
      : super(DataState(
          originalForecasts: [],
          forecasts: [],
          originalNews: [],
          news: [],
        ));

  Future<void> loadForecasts() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Charger les prévisions depuis l'API
      final forecasts = await apiService.fetchForecasts();

      emit(state.copyWith(
        originalForecasts: forecasts, // Stocker les prévisions originales
        forecasts: forecasts, // Initialiser la liste actuelle avec toutes les prévisions
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadNews() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Charger les actualités depuis l'API
      final news = await apiService.fetchNews();

      emit(state.copyWith(
        originalNews: news, // Stocker les actualités originales
        news: news, // Initialiser la liste actuelle avec toutes les actualités
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void updateFilterCategory(String? category) {
      emit(state.copyWith(filterCategory: category));
  }

  void updateSortType(SortType sortType) {
    emit(state.copyWith(sortType: sortType));
  }

  /// Appliquer les filtres, la recherche et le tri sur les prévisions
  List<Forecast> getFilteredForecasts() {
    var filteredForecasts = state.forecasts;

    // Filtrer par catégorie
    if (state.filterCategory != null) {
      filteredForecasts = filteredForecasts.where((n) => n.categorie.libelle == state.filterCategory).toList();
    }

    // Rechercher par texte
    if (state.searchQuery.isNotEmpty) {
      filteredForecasts = filteredForecasts
          .where((f) =>
              f.libelle.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
              f.description.toLowerCase().contains(state.searchQuery.toLowerCase()))
          .toList();
    }

    // Trier les résultats
    filteredForecasts.sort((a, b) {
      if (state.sortType == SortType.alphabetic) {
        return a.libelle.compareTo(b.libelle);
      } else {
        return b.updatedAt.compareTo(a.updatedAt); // Tri par date décroissante
      }
    });

    return filteredForecasts;
  }

  /// Appliquer les filtres, la recherche et le tri sur les actualités
  List<News> getFilteredNews() {
    var filteredNews = state.news;

    // Filtrer par catégorie
    if (state.filterCategory != null) {
      filteredNews = filteredNews.where((n) => n.categorie.libelle == state.filterCategory).toList();
    }

    // Rechercher par texte
    if (state.searchQuery.isNotEmpty) {
      filteredNews = filteredNews
          .where((n) =>
              n.libelle.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
              n.description.toLowerCase().contains(state.searchQuery.toLowerCase()))
          .toList();
    }

    // Trier les résultats
    filteredNews.sort((a, b) {
      if (state.sortType == SortType.alphabetic) {
        return a.libelle.compareTo(b.libelle);
      } else {
        return b.updatedAt.compareTo(a.updatedAt); // Tri par date décroissante
      }
    });

    return filteredNews;
  }
}
