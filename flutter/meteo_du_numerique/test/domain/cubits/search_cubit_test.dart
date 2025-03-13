import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_du_numerique/domain/cubits/search_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SearchCubit searchCubit;

  setUp(() {
    searchCubit = SearchCubit();
  });

  tearDown(() {
    searchCubit.close();
  });

  group('SearchCubit', () {
    test('initial state is SearchClosed', () {
      expect(searchCubit.state, isA<SearchClosed>());
    });

    test('openSearchBar changes state to SearchOpened', () {
      // Act
      searchCubit.openSearchBar();

      // Assert
      expect(searchCubit.state, isA<SearchOpened>());
    });

    test('closeSearchBar changes state to SearchClosed', () {
      // Arrange - first open the search bar
      searchCubit.openSearchBar();
      expect(searchCubit.state, isA<SearchOpened>());

      // Act
      searchCubit.closeSearchBar();

      // Assert
      expect(searchCubit.state, isA<SearchClosed>());
    });

    test('updateSearchQuery changes state to SearchQueryUpdated with correct query', () {
      // Act
      const query = 'test query';
      searchCubit.updateSearchQuery(query);

      // Assert
      expect(searchCubit.state, isA<SearchQueryUpdated>());
      expect((searchCubit.state as SearchQueryUpdated).query, equals(query));
    });

    test('clearAll resets search state completely', () {
      // Arrange
      searchCubit.openSearchBar();
      searchCubit.updateSearchQuery('test');

      // Act
      searchCubit.clearAll();

      // Assert - it should first emit ClearedAll, then SearchQueryUpdated, then SearchClosed
      // But since we're checking the final state only, it should be SearchClosed
      expect(searchCubit.state, isA<SearchClosed>());
    });
  });
}
