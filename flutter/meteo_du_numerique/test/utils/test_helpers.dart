import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/domain/cubits/app_cubit.dart';
import 'package:meteo_du_numerique/domain/cubits/search_cubit.dart';
import 'package:meteo_du_numerique/domain/cubits/theme_cubit.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes for testing with Mocktail
class MockThemeCubit extends Mock implements ThemeCubit {}

class MockSearchCubit extends Mock implements SearchCubit {}

class MockAppCubit extends Mock implements AppCubit {}

// Fake state classes for fallback value registration
class FakeThemeState extends Fake implements ThemeState {}

class FakeSearchState extends Fake implements SearchState {}

class FakeAppState extends Fake implements AppState {}

// Helper function to register all fallback values
void registerAllFallbackValues() {
  registerFallbackValue(FakeThemeState());
  registerFallbackValue(FakeSearchState());
  registerFallbackValue(FakeAppState());

  // Add additional fallback values as needed
}

// Helper to setup a ThemeCubit mock with default behavior
void setupThemeCubitMock(MockThemeCubit cubit) {
  final themeState = ThemeState(
    showForecasts: false,
    themeData: ThemeCubit.lightTheme,
    themeMode: ThemeMode.system,
    currentTheme: ThemeEvent.toggleSystem,
  );

  when(() => cubit.state).thenReturn(themeState);
  when(() => cubit.stream).thenAnswer((_) => Stream.value(themeState));
}

// Helper to setup a SearchCubit mock with default behavior
void setupSearchCubitMock(MockSearchCubit cubit) {
  final searchState = SearchClosed();

  when(() => cubit.state).thenReturn(searchState);
  when(() => cubit.stream).thenAnswer((_) => Stream.value(searchState));
}

// Helper to setup an AppCubit mock with default behavior
void setupAppCubitMock(MockAppCubit cubit) {
  final appState = AppState(tabIndex: 0, isBetaEnabled: false);

  when(() => cubit.state).thenReturn(appState);
  when(() => cubit.stream).thenAnswer((_) => Stream.value(appState));
}

// Helper to wrap widgets with necessary providers for testing
Widget wrapWithProviders(
  Widget child, {
  ThemeCubit? themeCubit,
  SearchCubit? searchCubit,
  AppCubit? appCubit,
}) {
  // Create and setup default mocks if not provided
  final mockThemeCubit = themeCubit ?? MockThemeCubit();
  final mockSearchCubit = searchCubit ?? MockSearchCubit();
  final mockAppCubit = appCubit ?? MockAppCubit();

  if (themeCubit == null) setupThemeCubitMock(mockThemeCubit as MockThemeCubit);
  if (searchCubit == null) setupSearchCubitMock(mockSearchCubit as MockSearchCubit);
  if (appCubit == null) setupAppCubitMock(mockAppCubit as MockAppCubit);

  return MaterialApp(
    home: MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: mockThemeCubit),
        BlocProvider<SearchCubit>.value(value: mockSearchCubit),
        BlocProvider<AppCubit>.value(value: mockAppCubit),
      ],
      child: Scaffold(body: child),
    ),
  );
}

// Helper for creating mock data for tests
class TestData {
  // Add factory methods to create test data for your models
  static Map<String, dynamic> createDigitalServiceJson({
    int id = 1,
    String name = 'Test Service',
    String description = 'Test Description',
  }) {
    return {
      'id': id,
      'name': name,
      'description': description,
      'url': 'https://example.com',
      'isVisible': true,
    };
  }

// Add more factory methods as needed
}
