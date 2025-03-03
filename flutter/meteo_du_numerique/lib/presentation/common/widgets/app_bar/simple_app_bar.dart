import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/blocs/theme/theme_bloc.dart';
import '../../../../domain/blocs/theme/theme_state.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SimpleAppBar({super.key});

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
          title: const Text("Digital Weather"),
          leading: Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/logo_academie_dark-Photoroom.png'
                : 'assets/Academie_de_Rennes_Logo_Vector.svg_-removebg-preview.png',
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