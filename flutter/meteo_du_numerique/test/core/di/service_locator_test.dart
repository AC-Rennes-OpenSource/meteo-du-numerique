import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:meteo_du_numerique/core/di/service_locator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ServiceLocator', () {
    test('serviceLocator should be available', () {
      // Assert
      expect(serviceLocator, isNotNull);
      expect(serviceLocator, isA<GetIt>());
    });

    // Note: We can't easily test the full setupServiceLocator because it depends on
    // Firebase initialization and other services that are challenging to mock in unit tests.
    // For a proper test, you would need to mock Firebase and other external dependencies.
  });
}
