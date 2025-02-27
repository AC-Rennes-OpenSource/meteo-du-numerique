import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/theme_bloc/theme_bloc.dart';
import '../../bloc/theme_bloc/theme_event.dart';
import '../../bloc/theme_bloc/theme_state.dart';
import '../../config/theme_preferences.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({super.key});

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    final themePreferences = ThemePreferences();

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        // print("state.showPrevision : ${state.showPrevision}");
        return Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRadioListTile(
                value: ThemeEvent.toggleLight,
                groupValue: state.currentTheme,
                title: 'Mode clair',
                icon: Icons.light_mode,
                themeBloc: themeBloc,
              ),
              _buildRadioListTile(
                value: ThemeEvent.toggleDark,
                groupValue: state.currentTheme,
                title: 'Mode sombre',
                icon: Icons.dark_mode,
                themeBloc: themeBloc,
              ),
              _buildRadioListTile(
                value: ThemeEvent.toggleSystem,
                groupValue: state.currentTheme,
                title: 'Mode de l\'appareil',
                icon: Icons.mobile_friendly,
                themeBloc: themeBloc,
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              //   child: Divider(),
              // ),
              // SwitchListTile(
              //   title: const Text(
              //     'Activer les prévisions (Beta)',
              //     style: TextStyle(fontSize: 15),
              //   ),
              //   secondary: const Icon(Icons.warning_amber),
              //   value: state.showPrevision,
              //   onChanged: (bool newValue) {
              //     themeBloc.add(ThemeEvent.showPrevision);
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRadioListTile({
    required ThemeEvent value,
    required ThemeEvent groupValue,
    required String title,
    required IconData icon,
    required ThemeBloc themeBloc,
  }) {
    return RadioListTile<ThemeEvent>(
      value: value,
      groupValue: groupValue,
      title: Text(title),
      secondary: Icon(icon),
      onChanged: (ThemeEvent? newValue) {
        if (newValue != null) {
          themeBloc.add(newValue);
          // Navigator.of(context).pop();
        }
      },
    );
  }
}
