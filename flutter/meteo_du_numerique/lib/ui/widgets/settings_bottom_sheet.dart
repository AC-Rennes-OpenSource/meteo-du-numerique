import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/items_bloc/items_bloc.dart';
import '../../bloc/items_bloc/items_event.dart';
import '../../bloc/previsions_bloc/previsions_bloc.dart';
import '../../bloc/theme_bloc/theme_bloc.dart';
import '../../bloc/theme_bloc/theme_event.dart';
import '../../bloc/theme_bloc/theme_state.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({super.key});

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {


  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
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
          Navigator.of(context).pop();
        }
      },
    );
  }
}
