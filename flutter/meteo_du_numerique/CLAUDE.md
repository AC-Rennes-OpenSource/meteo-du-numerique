# Meteo du Numerique - Flutter App Guidelines

## Build Commands
- `flutter pub get` - Install dependencies
- `flutter run` - Run app in debug mode
- `flutter run -d "iPhone 15 Pro"` - Run app on iPhone simulator
- `flutter test` - Run all tests
- `flutter test test/widget_test.dart` - Run specific test file
- `flutter analyze` - Run static analysis
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app
- `flutter pub run build_runner build` - Generate Freezed/JSON code

## Code Style
- Use camelCase for variables, methods, and file names (e.g., apiService, fetchData)
- Use PascalCase for classes, enums, typedefs
- Prefer final and const when variables aren't modified
- Use freezed annotations for models
- Use BLoC/Cubit for state management 
- Use GetIt for dependency injection (service_locator.dart)
- Organize imports in groups: dart, flutter, packages, project
- Parameter/variable nullable types are marked with `?`
- Use consistent error handling with try/catch blocks
- Models should implement a toJson() and fromJson() method
- Use the .env file for configuration variables
- Write descriptive documentation for complex methods

## Architecture
- Separate UI (widgets), logic (blocs/cubits), and data (models)
- Use service_locator.dart to register and access dependencies- \ - Run app on iPhone simulator
