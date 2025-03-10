part of 'data_cubit.dart';

enum SortType { alphabetic, date }

class DataState {
  final List<Forecast> originalForecasts; // Prévisions originales
  final List<News> originalNews; // Actualités originales
  final List<Forecast> forecasts;
  final List<News> news;
  final String searchQuery;
  final String? filterCategory;
  final SortType sortType;
  final bool isLoading;
  final String? error;

  DataState({
    required this.originalForecasts,
    required this.originalNews,
    required this.forecasts,
    required this.news,
    this.searchQuery = "",
    this.filterCategory,
    this.sortType = SortType.date,
    this.isLoading = false,
    this.error,
  });

  DataState copyWith({
    List<Forecast>? forecasts,
    List<News>? news,
    List<Forecast>? originalForecasts,
    List<News>? originalNews,
    String? searchQuery,
    String? filterCategory,
    SortType? sortType,
    bool? isLoading,
    String? error,
  }) {
    return DataState(
      originalForecasts: originalForecasts ?? this.forecasts,
      originalNews: originalNews ?? this.news,
      forecasts: forecasts ?? this.forecasts,
      news: news ?? this.news,
      searchQuery: searchQuery ?? this.searchQuery,
      filterCategory: filterCategory ?? this.filterCategory,
      sortType: sortType ?? this.sortType,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
