import 'package:flutter_bloc/flutter_bloc.dart';

class PreferencesState {
  final bool isDarkMode;
  final bool showFeatureX;
  final bool showNotifications;

  PreferencesState({
    required this.isDarkMode,
    required this.showFeatureX,
    required this.showNotifications,
  });

  PreferencesState copyWith({
    bool? isDarkMode,
    bool? showFeatureX,
    bool? showNotifications,
  }) {
    return PreferencesState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      showFeatureX: showFeatureX ?? this.showFeatureX,
      showNotifications: showNotifications ?? this.showNotifications,
    );
  }
}

class PreferencesCubit extends Cubit<PreferencesState> {
  PreferencesCubit()
      : super(PreferencesState(
    isDarkMode: false,
    showFeatureX: true,
    showNotifications: true,
  ));

  void toggleDarkMode() {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }

  void toggleFeatureX() {
    emit(state.copyWith(showFeatureX: !state.showFeatureX));
  }

  void toggleNotifications() {
    emit(state.copyWith(showNotifications: !state.showNotifications));
  }
}
