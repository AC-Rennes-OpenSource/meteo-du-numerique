import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/previsions_bloc/previsions_bloc.dart';
import '../../bloc/previsions_bloc/previsions_event.dart';
import '../../bloc/search_bar_bloc/search_bar_bloc.dart';
import '../../bloc/search_bar_bloc/search_bar_event.dart';
import '../../bloc/services_num_bloc/services_num_bloc.dart';
import '../../bloc/services_num_bloc/services_num_event.dart';
import '../../bloc/services_num_bloc/services_num_state.dart';
import '../../cubit/app_cubit.dart';
import '../../utils.dart';
import 'custom_search_bar.dart';

class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ThemedAppBar({super.key, this.tabBar, required this.onTitleTap});

  final TabBar? tabBar;
  final void Function(BuildContext) onTitleTap;

  @override
  Widget build(BuildContext context) {
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
                              icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.onSecondaryContainer),
                              onPressed: () {
                                BlocProvider.of<ServicesNumBloc>(context).add(FilterServicesNumEvent([]));
                                BlocProvider.of<ServicesNumBloc>(context).add(SortServicesNumEvent('qualiteDeServiceId', 'desc'));
                                BlocProvider.of<PrevisionsBloc>(context).add(FilterPrevisionsEvent([], 'all'));

                                CustomSearchBar.closeKeyboard(context);
                                tabBar?.controller?.animateTo(0);
                                context.read<AppCubit>().changeTab(0);
                                context.read<SearchBarBloc>().add(ClearAllEvent());
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
                        Utils.lastUpdateString(displayedLastUpdate),
                      ),
                    ),
                  ],
                ),
              )
            : PreferredSize(
                preferredSize: preferredSize,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    style: const TextStyle(fontSize: 9),
                    Utils.lastUpdateString(displayedLastUpdate),
                  ),
                ),
              ),
      );
    });
  }

  @override
  Size get preferredSize => tabBar != null ? const Size.fromHeight(150) : const Size.fromHeight(80);
}
