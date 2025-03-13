import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_du_numerique/data/models/category.dart';
import 'package:meteo_du_numerique/data/models/digital_service.dart';
import 'package:meteo_du_numerique/data/models/service_quality.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DigitalService Model', () {
    test('should create a basic DigitalService instance', () {
      // Arrange & Act
      final service = DigitalService(
        id: 1,
        name: 'Test Service',
        description: 'Test Description',
        url: 'https://example.com',
        isVisible: true,
      );

      // Assert
      expect(service.id, 1);
      expect(service.name, 'Test Service');
      expect(service.description, 'Test Description');
      expect(service.url, 'https://example.com');
      expect(service.isVisible, true);
    });

    test('should create a complete DigitalService instance with relationships', () {
      // Arrange
      final category = Category(
        id: 1,
        name: 'Test Category',
      );

      final quality = ServiceQuality(
        id: 1,
        name: 'nominal',
        description: 'Everything is working',
        color: '#00FF00',
      );

      // Act
      final service = DigitalService(
        id: 1,
        name: 'Test Service',
        description: 'Test Description',
        url: 'https://example.com',
        category: category,
        qualityOfService: quality,
        isVisible: true,
      );

      // Assert
      expect(service.id, 1);
      expect(service.category, category);
      expect(service.qualityOfService, quality);
    });
  });
}
