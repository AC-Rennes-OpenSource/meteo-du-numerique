import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_du_numerique/core/config/flavor_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FlavorConfig', () {
    test('init should set flavor to prod when "prod" is provided', () {
      // Act
      FlavorConfig.init('prod');

      // Assert
      expect(FlavorConfig.flavor, equals(Flavor.prod));
    });

    test('init should set flavor to test when "test" is provided', () {
      // Act
      FlavorConfig.init('test');

      // Assert
      expect(FlavorConfig.flavor, equals(Flavor.test));
    });

    test('init should set flavor to testProd for any other value', () {
      // Act
      FlavorConfig.init('unknown');

      // Assert
      expect(FlavorConfig.flavor, equals(Flavor.testProd));
    });
  });
}
