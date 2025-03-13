import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/blocs/digital_services/digital_services_bloc.dart';
import '../../../../domain/blocs/digital_services/digital_services_event.dart';
import '../../../../domain/blocs/digital_services/digital_services_state.dart';
import '../../../../domain/blocs/forecasts/forecasts_bloc.dart';
import '../../../../domain/blocs/forecasts/forecasts_event.dart';
import '../../../../domain/cubits/app_cubit.dart';
import '../../../../domain/cubits/search_cubit.dart';
import '../../../../utils.dart';
import '../search_bar/custom_search_bar.dart';

class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ThemedAppBar({super.key, this.tabBar, required this.onTitleTap});

  final TabBar? tabBar;
  final void Function(BuildContext) onTitleTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DigitalServicesBloc, DigitalServicesState>(builder: (context, state) {
      DateTime? displayedLastUpdate;

      if (state is DigitalServicesLoaded && state.lastUpdate != null && displayedLastUpdate != state.lastUpdate) {
        displayedLastUpdate = state.lastUpdate;
      }

      return AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
        centerTitle: true,
        title: GestureDetector(
          onTap: () => onTitleTap(context),
          child: SizedBox(
            height: kToolbarHeight,
            child: Center(child: const Text("Météo du numérique")),
          ),
        ),
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
                        child: Row(
                          children: [
                            Expanded(
                              child: tabBar!,
                            ),
                            IconButton(
                              icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.onSecondaryContainer),
                              onPressed: () {
                                BlocProvider.of<DigitalServicesBloc>(context).add(FilterDigitalServicesEvent([]));
                                BlocProvider.of<DigitalServicesBloc>(context).add(SortDigitalServicesEvent('serviceQualityId', 'desc'));

                                BlocProvider.of<ForecastsBloc>(context).add(FilterForecastsEvent([], 'all'));

                                CustomSearchBar.closeKeyboard(context);
                          tabBar?.controller?.animateTo(0);
                          context.read<AppCubit>().changeTab(0);
                          context.read<SearchCubit>().clearAll();
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
