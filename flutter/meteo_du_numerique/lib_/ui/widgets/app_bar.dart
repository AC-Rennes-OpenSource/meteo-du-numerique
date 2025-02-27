import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/items_bloc/services_num_bloc.dart';
import '../../bloc/items_bloc/services_num_event.dart';
import '../../bloc/items_bloc/services_num_state.dart';
import '../../bloc/search_bar_bloc/search_bar_bloc.dart';
import '../../bloc/search_bar_bloc/search_bar_event.dart';
import '../../cubit/app_cubit.dart';
import '../../cubit/previsions_cubit.dart';
import '../../cubit/services_numeriques_cubit.dart';
import 'custom_search_bar_2.dart';

class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ThemedAppBar({super.key, this.tabBar, required this.onTitleTap});

  final TabBar? tabBar;
  final void Function(BuildContext) onTitleTap;

  @override
  Widget build(BuildContext context) {
    final servicesState = context.watch<ServicesNumeriquesCubit>().state;
    final previsionsState = context.watch<PrevisionsCubit>().state;

    final lastUpdateServices =
        servicesState.allServices.isNotEmpty ? servicesState.allServices.map((s) => s.lastUpdate).reduce((a, b) => a.isAfter(b) ? a : b) : null;
    final lastUpdatePrevisions = previsionsState.allPrevisions.isNotEmpty
        ? previsionsState.allPrevisions.map((p) => p.lastUpdate).reduce((a, b) => a.isAfter(b) ? a : b)
        : null;

    final lastUpdate = [lastUpdateServices, lastUpdatePrevisions].whereType<DateTime>().reduce((a, b) => a.isAfter(b) ? a : b);

    return BlocBuilder<ServicesNumBloc, ServicesNumState>(builder: (context, state) {
      DateTime? displayedLastUpdate;

      if (state is ServicesNumLoaded && state.lastUpdate != null && displayedLastUpdate != state.lastUpdate) {
        displayedLastUpdate = state.lastUpdate;
      }

      return AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
        centerTitle: true,
        // title: ,
        title: GestureDetector(
          onTap: () => onTitleTap(context),
          child: SizedBox(
            height: kToolbarHeight, // Hauteur standard pour un AppBar
            child: Center(child: const Text("Météo du numérique")),
          ),
        ),
        leading: Image.asset(
          Theme.of(context).brightness == Brightness.dark ? 'assets/logo_academie_dark.png' : 'assets/logo_academie.jpg',
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
        bottom: tabBar != null
            ? PreferredSize(
                preferredSize: tabBar!.preferredSize,
                child: Column(
                  children: [
                    Theme(
                      data: Theme.of(context)
                          .copyWith(highlightColor: Colors.transparent, splashColor: Colors.transparent, textTheme: Theme.of(context).textTheme),
                      child: Container(
                        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child:

                            // tabBar,

                            Row(
                          children: [
                            Expanded(
                              child: tabBar!,
                            ),
                            IconButton(
                              icon: Icon(Icons.replay),
                              onPressed: () {
                                BlocProvider.of<ServicesNumBloc>(context).add(FilterServicesNumEvent([]));
                                BlocProvider.of<ServicesNumBloc>(context).add(SortServicesNumEvent('qualiteDeServiceId', 'desc'));

                                //TODO
                                // BlocProvider.of<PrevisionsBloc>(context).add(FilterPrevisionsEvent([], 'all'));

                                CustomSearchBar.closeKeyboard(context);
                                context.read<AppCubit>().changeTab(0);
                                context.read<SearchBarBloc>().add(ClearAllEvent());
                                // BlocProvider.of<ServicesNumBloc>(context).add(SearchItemsEvent(''));
                                // BlocProvider.of<SearchBarBloc>(context).add(CloseSearchBar());
                                // BlocProvider.of<SearchBarBloc>(context).add(UpdateSearchQuery(''));

                                // BlocProvider.of<PrevisionsBloc>(context).add(SearchPrevisionsEvent(''));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        style: const TextStyle(fontSize: 9),
                        'Dernière mise à jour: ${lastUpdate != null ? DateFormat('dd/MM/yyyy HH:mm').format(lastUpdate) : 'N/A'}',
                      ),
                    ),
                  ],
                ),
              )
            : null,
      );
    });
  }

  @override
  Size get preferredSize => tabBar != null ? const Size.fromHeight(150) : const Size.fromHeight(70);
}
