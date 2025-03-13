import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_du_numerique/domain/cubits/theme_cubit.dart';
import 'package:meteo_du_numerique/presentation/common/widgets/theme_switch/theme_switch.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeCubit extends Mock implements ThemeCubit {}

class FakeThemeState extends Fake implements ThemeState {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockThemeCubit mockThemeCubit;

  setUpAll(() {
    registerFallbackValue(FakeThemeState());
  });

  setUp(() {
    mockThemeCubit = MockThemeCubit();

    // Setup default state behavior
    final themeState = ThemeState(
      showForecasts: false,
      themeData: ThemeCubit.lightTheme,
      themeMode: ThemeMode.light,
      currentTheme: ThemeEvent.toggleLight,
    );

    when(() => mockThemeCubit.state).thenReturn(themeState);
    when(() => mockThemeCubit.stream).thenAnswer((_) => Stream.value(themeState));
  });

  group('ThemeSwitch Widget', () {
    testWidgets('should render', (WidgetTester tester) async {
      // Build widget
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ThemeCubit>.value(
            value: mockThemeCubit,
            child: const Scaffold(
              body: ThemeSwitch(),
            ),
          ),
        ),
      );

      // Verify the widget exists
      expect(find.byType(ThemeSwitch), findsOneWidget);
    });
  });
}
