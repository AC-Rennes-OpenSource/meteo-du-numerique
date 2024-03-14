import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_bloc.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_event.dart';
import 'package:meteo_du_numerique/ui/widgets/custom_search_bar.dart';
import 'package:meteo_du_numerique/ui/widgets/expansion_list.dart';
import 'package:meteo_du_numerique/ui/widgets/sort_bottom_sheet.dart';
import 'package:meteo_du_numerique/ui/widgets/theme_switch.dart';

import '../../bloc/items_bloc/services_num_bloc.dart';
import '../../bloc/items_bloc/services_num_event.dart';
import '../../bloc/items_bloc/services_num_state.dart';
import '../../bloc/previsions_bloc/previsions_state.dart';
import '../../bloc/search_bar_bloc/search_bar_bloc.dart';
import '../../bloc/search_bar_bloc/search_bar_event.dart';
import '../../bloc/theme_bloc/theme_bloc.dart';
import '../../bloc/theme_bloc/theme_state.dart';
import '../../utils.dart';
import '../decorations/rounded_rect_tab_indicator.dart';
import '../widgets/app_bar.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/filter_previsions_bottom_sheet.dart';
import '../widgets/items_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final servicesNumBloc = BlocProvider.of<ServicesNumBloc>(context);
    final previsionsBloc = BlocProvider.of<PrevisionsBloc>(context);

    ValueNotifier<int> tabIndexNotifier = ValueNotifier(0);

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return DefaultTabController(
            initialIndex: 0,
            length: 2, // Nombre d'onglets
            child: Scaffold(
                backgroundColor: Theme.of(context).brightness == Brightness.dark ? null : Colors.grey.shade200,
                appBar: ThemedAppBar(
                  tabBar: TabBar(
                    overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                    splashBorderRadius: const BorderRadius.all(Radius.circular(40)),
                    unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
                    labelColor: Theme.of(context).colorScheme.onSecondary,
                    onTap: (index) {
                      tabIndexNotifier.value = index;
                    },
                    enableFeedback: true,
                    indicatorPadding: const EdgeInsets.all(3),
                    indicator: RoundedRectTabIndicator(
                        color: Theme.of(context).colorScheme.primary,
                        radius: 40,
                        borderColor: Colors.transparent,
                        borderWidth: 1),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(
                        child: Text(
                          'Météo du jour',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Prévisions',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                body: ValueListenableBuilder<int>(
                    valueListenable: tabIndexNotifier,
                    builder: (context, tabIndex, child) {
                      return NestedScrollView(
                        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            BlocBuilder<ThemeBloc, ThemeState>(
                              builder: (context, state) {
                                DefaultTabController.of(context).animation?.addListener(() {
                                  if (tabIndexNotifier.value !=
                                      DefaultTabController.of(context).animation!.value.round()) {
                                    tabIndexNotifier.value = DefaultTabController.of(context).index.round();
                                  }
                                });

                                return SliverAppBar(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35))),
                                  toolbarHeight: 72,
                                  scrolledUnderElevation: 0,
                                  backgroundColor:
                                      Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                                  pinned: false,
                                  floating: true,
                                  snap: true,
                                  title: Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0),
                                          child: Text(
                                            style: const TextStyle(fontSize: 9
                                                ),
                                            Utils.lastUpdateString(servicesNumBloc.lastUpdate!),
                                          )),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: tabIndex == 0
                                                      ? BlocBuilder<ServicesNumBloc, ServicesNumState>(
                                                          builder: (context2, state) {
                                                            return Stack(children: [
                                                              OutlinedButton.icon(
                                                                icon: const Icon(Icons.filter_list),
                                                                label: const Text('Filtres'),
                                                                onPressed: () => _showFilterBottomSheet(
                                                                    context,
                                                                    servicesNumBloc,
                                                                    previsionsBloc,
                                                                    tabIndexNotifier.value),
                                                                style: OutlinedButton.styleFrom(
                                                                    side: const BorderSide(
                                                                        width: 1.0, color: Colors.grey),
                                                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                                    minimumSize: const Size(110, 30),
                                                                    foregroundColor:
                                                                        Theme.of(context).colorScheme.onSurface),
                                                              ),
                                                              // badge sur bouton
                                                              if (BlocProvider.of<ServicesNumBloc>(context2)
                                                                  .currentFilterCriteria!
                                                                  .isNotEmpty)
                                                                Positioned(
                                                                  right: 0,
                                                                  top: 5,
                                                                  child: Container(
                                                                    padding: const EdgeInsets.all(2),
                                                                    decoration: BoxDecoration(
                                                                      // border: Border.all(color: Theme.of(context).colorScheme.onSurface),
                                                                      color: Colors.redAccent,
                                                                      borderRadius: BorderRadius.circular(20),
                                                                    ),
                                                                    constraints: const BoxConstraints(
                                                                      minWidth: 15,
                                                                      minHeight: 15,
                                                                    ),
                                                                    child: const Icon(
                                                                      Icons.check,
                                                                      size: 10,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                ),
                                                            ]);
                                                          },
                                                        )
                                                      : BlocBuilder<PrevisionsBloc, PrevisionsState>(
                                                          builder: (context3, state) {
                                                            return Stack(children: [
                                                              OutlinedButton.icon(
                                                                icon: const Icon(Icons.filter_list),
                                                                label: const Text('Filtres'),
                                                                onPressed: () => _showFilterBottomSheet(
                                                                    context,
                                                                    servicesNumBloc,
                                                                    previsionsBloc,
                                                                    tabIndexNotifier.value),
                                                                style: OutlinedButton.styleFrom(
                                                                    side: const BorderSide(
                                                                        width: 1.0, color: Colors.grey),
                                                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                                    minimumSize: const Size(110, 30),
                                                                    foregroundColor:
                                                                        Theme.of(context).colorScheme.onSurface),
                                                              ),
                                                              // badge sur bouton
                                                              if (BlocProvider.of<PrevisionsBloc>(context3)
                                                                      .currentFilterCriteria
                                                                      .isNotEmpty ||
                                                                  BlocProvider.of<PrevisionsBloc>(context3)
                                                                          .currentPeriode !=
                                                                      'all')
                                                                Positioned(
                                                                  right: 0,
                                                                  top: 5,
                                                                  child: Container(
                                                                    padding: const EdgeInsets.all(2),
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.redAccent,
                                                                      borderRadius: BorderRadius.circular(6),
                                                                    ),
                                                                    constraints: const BoxConstraints(
                                                                      minWidth: 15,
                                                                      minHeight: 15,
                                                                    ),
                                                                    child: const Icon(
                                                                      Icons.check,
                                                                      size: 10,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                ),
                                                            ]);
                                                          },
                                                        )),
                                              const SizedBox(
                                                width: 6.0,
                                              ),
                                              tabIndex == 0
                                                  ? OutlinedButton.icon(
                                                      icon: const Icon(Icons.sort),
                                                      label: const Text('Tri'),
                                                      onPressed: () => _showSortBottomSheet(context, servicesNumBloc),
                                                      style: OutlinedButton.styleFrom(
                                                          side: const BorderSide(width: 1.0, color: Colors.grey),
                                                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                          minimumSize: const Size(90, 30),
                                                          foregroundColor: Theme.of(context).colorScheme.onSurface),
                                                    )
                                                  : const SizedBox(
                                                      width: 90,
                                                    ),
                                            ],
                                          ),
                                          const ThemeSwitch(),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ];
                        },
                        body: TabBarView(
                          children: [
                            Platform.isIOS
                                ? CustomScrollView(
                                    slivers: [
                                      CupertinoSliverRefreshControl(
                                        onRefresh: () async {
                                          previsionsBloc.add(FetchPrevisionsEvent());
                                          servicesNumBloc.add(FetchServicesNumEvent(showIndicator: false));
                                        },
                                      ),
                                      const ExpansionList(dayPrevison: true),
                                      const ItemsList(),
                                    ],
                                  )
                                : RefreshIndicator(
                                    onRefresh: () async {
                                      previsionsBloc.add(FetchPrevisionsEvent());
                                      servicesNumBloc.add(FetchServicesNumEvent(showIndicator: false));
                                    },
                                    child: const CustomScrollView(
                                      slivers: [
                                        ExpansionList(dayPrevison: true),
                                        ItemsList(),
                                      ],
                                    ),
                                  ),
                            Platform.isIOS
                                ? CustomScrollView(
                                    slivers: [
                                      CupertinoSliverRefreshControl(
                                        onRefresh: () async {
                                          // TODO ouvrir l'accordéon à chaque refresh?
                                          previsionsBloc.add(FetchPrevisionsEvent());
                                          previsionsBloc.add(OpenAllGroupsEvent());
                                        },
                                      ),
                                      const ExpansionList(
                                        dayPrevison: false,
                                      ),
                                    ],
                                  )
                                : RefreshIndicator(
                                    onRefresh: () async {
                                      previsionsBloc.add(FetchPrevisionsEvent());
                                      previsionsBloc.add(OpenAllGroupsEvent());
                                    },
                                    child: const CustomScrollView(
                                      slivers: [
                                        ExpansionList(
                                          dayPrevison: false,
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      );
                    }),
                floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
                floatingActionButton: ValueListenableBuilder<int>(
                    valueListenable: tabIndexNotifier,
                    builder: (context, tabIndex, child) {
                      return CustomSearchBar(
                        tabIndexNotifier: tabIndexNotifier,
                      );
                    })));
      },
    );
  }

  void _showSortBottomSheet(BuildContext context, ServicesNumBloc itemsBloc) {
    FocusScope.of(context).unfocus();
    String? currentSorting = itemsBloc.currentSortCriteria;
    String? currentOrder = itemsBloc.currentSortOrder;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SortBottomSheet(
          itemsBloc: itemsBloc,
          selectedSorting: currentSorting,
          selectedOrder: currentOrder,
        );
      },
    ).then((_) {
      context.read<SearchBarBloc>().add(CloseSearchBar());
    });
  }

  void _showFilterBottomSheet(BuildContext context, ServicesNumBloc itemsBloc, PrevisionsBloc previsionsBloc, int tab) {
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
      scrollControlDisabledMaxHeightRatio: 0.75,
      context: context,
      builder: (BuildContext bc) {
        return tab == 0
            ? FilterBottomSheet(
                selectedFilters: itemsBloc.currentFilters,
                tab: tab,
              )
            : FilterPrevisionsBottomSheet(
                selectedFilter: previsionsBloc.currentPeriode,
                tab: tab,
                selectedCategories: previsionsBloc.currentFilterCriteria,
              );
      },
    ).then((_) {
      context.read<SearchBarBloc>().add(CloseSearchBar());
    });
  }
}
