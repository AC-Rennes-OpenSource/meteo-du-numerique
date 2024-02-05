import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_bloc.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_event.dart';
import 'package:meteo_du_numerique/ui/widgets/custom_search_bar.dart';
import 'package:meteo_du_numerique/ui/widgets/expansion_list.dart';
import 'package:meteo_du_numerique/ui/widgets/sort_bottom_sheet.dart';
import 'package:meteo_du_numerique/ui/widgets/theme_switch.dart';

import '../../bloc/items_bloc/items_bloc.dart';
import '../../bloc/items_bloc/items_event.dart';
import '../../bloc/search_bar_bloc/search_bar_bloc.dart';
import '../../bloc/search_bar_bloc/search_bar_event.dart';
import '../../bloc/theme_bloc/theme_bloc.dart';
import '../../bloc/theme_bloc/theme_state.dart';
import '../decorations/rounded_rect_tab_indicator.dart';
import '../widgets/app_bar.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/filter_previsions_bottom_sheet.dart';
import '../widgets/items_list.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    final itemsBloc = BlocProvider.of<ItemsBloc>(context);
    final previsionsBloc = BlocProvider.of<PrevisionsBloc>(context);

    ValueNotifier<int> tabIndexNotifier = ValueNotifier(0);

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return DefaultTabController(
            initialIndex: 0,
            length: 2, // Nombre d'onglets
            child: Scaffold(
                backgroundColor: themeBloc.state.isDarkMode ? null : Colors.grey.shade200,
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
                                DefaultTabController.of(context).animation?.addListener(() => {
                                      if (tabIndexNotifier.value !=
                                          DefaultTabController.of(context).animation!.value.round())
                                        {
                                          tabIndexNotifier.value = DefaultTabController.of(context).index.round(),
                                        }
                                    });

                                return SliverAppBar(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35))),
                                  toolbarHeight: 72,
                                  scrolledUnderElevation: 0,
                                  backgroundColor: themeBloc.state.isDarkMode ? Colors.black : Colors.white,
                                  pinned: false,
                                  floating: true,
                                  snap: true,
                                  title: Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0),
                                          child: Text(
                                            style: const TextStyle(fontSize: 9
                                                // todo rst
                                                ),
                                            lastUpdateString(itemsBloc.lastUpdate!),
                                          )),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: OutlinedButton.icon(
                                                  icon: const Icon(Icons.filter_list),
                                                  label: const Text('Filtres'),
                                                  onPressed: () => _showFilterBottomSheet(
                                                      context, itemsBloc, previsionsBloc, tabIndexNotifier.value),
                                                  style: OutlinedButton.styleFrom(
                                                      side: const BorderSide(width: 1.0, color: Colors.grey),
                                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                      minimumSize: const Size(110, 30),
                                                      foregroundColor: Theme.of(context).colorScheme.onSurface),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 6.0,
                                              ),
                                              tabIndex == 0
                                                  ? OutlinedButton.icon(
                                                      icon: const Icon(Icons.sort),
                                                      label: const Text('Tri'),
                                                      onPressed: () => _showSortBottomSheet(context, itemsBloc),
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
                                          itemsBloc.add(FetchItemsEvent(showIndicator: false));
                                          // Ajoutez un délai si nécessaire pour simuler le temps de chargement
                                          await Future.delayed(const Duration(milliseconds: 250));
                                        },
                                      ),
                                      const ExpansionList(dayPrevison: true),
                                      const ItemsList(),
                                    ],
                                  )
                                : RefreshIndicator(
                                    onRefresh: () async {
                                      itemsBloc.add(FetchItemsEvent(showIndicator: false));
                                      await Future.delayed(const Duration(milliseconds: 250));
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
                                          // todo rst ouvrir l'accordéon à chaque refresh?
                                          previsionsBloc.add(OpenAllGroupsEvent());
                                          // délai pour simuler le temps de chargement
                                          await Future.delayed(const Duration(milliseconds: 250));
                                        },
                                      ),
                                      const ExpansionList(
                                        dayPrevison: false,
                                      ),
                                    ],
                                  )
                                : RefreshIndicator(
                                    onRefresh: () async {
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
                        tabIndex: tabIndex,
                      );
                    })));
      },
    );
  }

  void _showSortBottomSheet(BuildContext context, ItemsBloc itemsBloc) {
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

  void _showFilterBottomSheet(BuildContext context, ItemsBloc itemsBloc, PrevisionsBloc previsionsBloc, int tab) {
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
                // todo rst
                selectedCategories: previsionsBloc.currentFilterCriteria,
              );
      },
    ).then((_) {
      context.read<SearchBarBloc>().add(CloseSearchBar());
    });
  }

  String lastUpdateString(DateTime lastUpdate) {
    String form = DateFormat("dd MMMM yyyy", "fr_FR").format(lastUpdate);
    String hour =
        "${DateFormat("H").format(lastUpdate.add(const Duration(hours: 2)))}h${DateFormat("mm").format(lastUpdate)}";
    return "Dernière mise à jour le $form à $hour";
  }
}
