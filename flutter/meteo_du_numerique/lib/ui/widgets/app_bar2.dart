import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/theme_bloc/theme_bloc.dart';
import '../../bloc/theme_bloc/theme_state.dart';

class AppBar2 extends StatelessWidget implements PreferredSizeWidget {
  const AppBar2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          centerTitle: true,
          title: const Text("Météo du numérique"),
          leading: Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/logo_academie_dark.png'
                : 'assets/logo_academie.jpg',
          ),
          actions: [
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Image.asset(
                'assets/icon-meteo-round.png',
                width: 40.0,
              ),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
