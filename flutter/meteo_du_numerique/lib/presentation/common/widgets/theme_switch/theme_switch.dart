import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/presentation/shared/bottom_sheets/settings_bottom_sheet.dart';

import '../../../../domain/blocs/theme/theme_bloc.dart';
import '../../../../domain/blocs/theme/theme_state.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Row(
          children: [
            IconButton(
              onPressed: () => _showThemeSettings(context),
              icon: const Icon(Icons.tune),
            ),
          ],
        );
      },
    );
  }

  void _showThemeSettings(BuildContext context) {
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Get the ThemeBloc instance from the original context
        // and provide it to the modal bottom sheet context
        return BlocProvider.value(
          value: BlocProvider.of<ThemeBloc>(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Text(
                  "Préférences",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                child: Divider(),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 50),
                child: SettingsBottomSheet(),
              ),
            ],
          ),
        );
      }
    );
  }
}