import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_bloc.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_event.dart';

import '../../bloc/items_bloc/services_num_bloc.dart';
import '../../bloc/items_bloc/services_num_event.dart';
import '../../bloc/theme_bloc/theme_bloc.dart';
import '../../bloc/theme_bloc/theme_state.dart';

class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ThemedAppBar({super.key, required this.tabBar});

  final TabBar tabBar;

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
                'assets/icon_meteo_dark.png',
                width: 40.0,
              ),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: tabBar.preferredSize,
            child: Theme(
              data: Theme.of(context).copyWith(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  textTheme: Theme.of(context).textTheme),
              child: Container(
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 10, top: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child:

                  // tabBar

                  Row(
                    children: [
                      Expanded(
                        child: tabBar,
                      ),
                      IconButton(
                        icon: Icon(Icons.replay),
                        onPressed: () {
                          BlocProvider.of<ServicesNumBloc>(context).add(FilterServicesNumEvent([]));
                          BlocProvider.of<ServicesNumBloc>(context).add(SortServicesNumEvent('qualiteDeServiceId', 'asc'));
                          BlocProvider.of<PrevisionsBloc>(context).add(FilterPrevisionsEvent([], 'all'));
                          // BlocProvider.of<ServicesNumBloc>(context).add(SearchItemsEvent(''));
                          // BlocProvider.of<PrevisionsBloc>(context).add(SearchPrevisionsEvent(''));

                        },
                      ),
                    ],
                  ),

              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}
