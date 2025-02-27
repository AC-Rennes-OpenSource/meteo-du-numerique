import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/ui/widgets/settings_bottom_sheet.dart';

import '../../bloc/theme_bloc/theme_bloc.dart';
import '../../bloc/theme_bloc/theme_state.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Row(
          children: [
            IconButton(
              onPressed: () => _showThemeChooser(context),
              icon: const Icon(Icons.tune),
            ),
          ],
        );
      },
    );
  }

  void _showThemeChooser(BuildContext context) {
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child:
                    // todo titre + icone pour fermer la bottomsheet (mais pb de darkmode quand on switch)
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    //   child:
                    //   Row(
                    //     children: [
                    //       const SizedBox(width: 48),
                    //       Expanded(
                    //         child: Center(
                    //           child: Text(
                    //             'Préférences',
                    //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    //             textAlign: TextAlign.center,
                    //           ),
                    //         ),
                    //       ),
                    //
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 8.0),
                    //         child: IconButton(
                    //           icon: const Icon(Icons.close),
                    //           onPressed: () => Navigator.of(context).pop(),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Text(
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
          );
        });
  }
}
