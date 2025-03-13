import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/presentation/theme/theme_event.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../domain/blocs/theme/theme_bloc.dart';
import '../../../domain/blocs/theme/theme_state.dart';


class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({super.key});

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Météo du Numérique',
    packageName: '',
    version: '',
    buildNumber: '',
    buildSignature: '',
    installerStore: '',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Divider(),
              ),
              SwitchListTile(
                title: const Text(
                  'Activer les prévisions (Beta)',
                  style: TextStyle(fontSize: 15),
                ),
                secondary: const Icon(Icons.warning_amber),
                value: state.showForecasts,
                onChanged: (bool newValue) {
                  themeBloc.add(ThemeEvent.toggleForecastsVisibility);
                },
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              //   child: Divider(),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text('v${_packageInfo.version}(${_packageInfo.buildNumber})',
                    style: TextStyle(
                      fontSize: 8,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.end),
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
        }
      },
    );
  }
}