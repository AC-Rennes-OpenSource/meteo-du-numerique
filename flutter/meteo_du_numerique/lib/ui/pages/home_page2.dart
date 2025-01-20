import 'dart:async';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_bloc_2.dart';
import 'package:meteo_du_numerique/ui/widgets/custom_search_bar.dart';
import 'package:meteo_du_numerique/ui/widgets/sort_bottom_sheet.dart';
import 'package:meteo_du_numerique/ui/widgets/theme_switch.dart';

import '../../bloc/items_bloc/services_num_bloc.dart';
import '../../bloc/items_bloc/services_num_event.dart';
import '../../bloc/items_bloc/services_num_state.dart';
import '../../bloc/previsions_bloc/previsions_event.dart';
import '../../bloc/previsions_bloc/previsions_state.dart';
import '../../bloc/theme_bloc/theme_bloc.dart';
import '../../bloc/theme_bloc/theme_state.dart';
import '../../utils.dart';
import '../decorations/rounded_rect_tab_indicator.dart';
import '../widgets/app_bar.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/filter_previsions_bottom_sheet.dart';
import '../widgets/items_list.dart';

class HomePage2 extends StatelessWidget {

  // Variable statique pour gérer le compteur de taps
  static int _tapCount = 0;
  static DateTime? _lastTapTime;
  static Timer? _tapTimer;

  const HomePage2({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteConfig = FirebaseRemoteConfig.instance;

    final servicesNumBloc = BlocProvider.of<ServicesNumBloc>(context);
    final previsionsBloc = BlocProvider.of<PrevisionsBloc>(context);
    _refreshAll(context);
    DateTime? displayedLastUpdate;

    // ValueNotifier<int> tabIndexNotifier = ValueNotifier(0);
    return BlocBuilder<ServicesNumBloc, ServicesNumState>(
        builder: (context, servicesState) {
      if (servicesState is ServicesNumLoaded &&
          servicesState.lastUpdate != null) {
        displayedLastUpdate = servicesState.lastUpdate;
      }
      return BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? null
                    : Colors.grey.shade200,
                appBar: ThemedAppBar(
                  onTitleTap: _handleTap,
                  tabBar:
                  !remoteConfig.getBool("show_previsions") ? TabBar(
                    overlayColor: WidgetStateColor.resolveWith(
                        (states) => Colors.transparent),
                    splashBorderRadius:
                        const BorderRadius.all(Radius.circular(40)),
                    unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
                    labelColor: Theme.of(context).colorScheme.onSecondary,
                    onTap: (index) {
                      // tabIndexNotifier.value = index;
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
                    tabs: [
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
                  ) :
                  null,
                ),
                body: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      BlocBuilder<ThemeBloc, ThemeState>(
                        builder: (context, state) {
                          // DefaultTabController.of(context)
                          //     .animation
                          //     ?.addListener(() {
                          //   if (tabIndexNotifier.value !=
                          //       DefaultTabController.of(context)
                          //           .animation!
                          //           .value
                          //           .round()) {
                          //     tabIndexNotifier.value =
                          //         DefaultTabController.of(context)
                          //             .index
                          //             .round();
                          //   }
                          // });

                              return SliverAppBar(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(35),
                                        bottomRight: Radius.circular(35))),
                                toolbarHeight: 72,
                                scrolledUnderElevation: 0,
                                backgroundColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                                pinned: false,
                                floating: true,
                                snap: true,
                                title: Column(
                                  children: [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12.0),
                                        child: Text(
                                          style: const TextStyle(fontSize: 9),
                                          displayedLastUpdate != null
                                              ? Utils.lastUpdateString(
                                                  displayedLastUpdate!)
                                              : '',
                                        )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: BlocBuilder<
                                                    ServicesNumBloc,
                                                    ServicesNumState>(
                                                  builder: (context2, state) {
                                                    return Stack(children: [
                                                      OutlinedButton.icon(
                                                        icon: const Icon(
                                                            Icons.filter_list),
                                                        label:
                                                            const Text('Filtres'),
                                                        onPressed: () =>
                                                            _showFilterBottomSheet(
                                                                context,
                                                                servicesNumBloc,
                                                                previsionsBloc,
                                                                0),
                                                        style: OutlinedButton.styleFrom(
                                                            iconColor: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSurface,
                                                            side:
                                                                const BorderSide(
                                                                    width: 1.0,
                                                                    color: Colors
                                                                        .grey),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        5.0),
                                                            minimumSize:
                                                                const Size(
                                                                    110, 30),
                                                            foregroundColor:
                                                                Theme.of(context)
                                                                    .colorScheme
                                                                    .onSurface),
                                                      ),
                                                      // badge sur bouton
                                                      if (BlocProvider.of<
                                                                  ServicesNumBloc>(
                                                              context2)
                                                          .currentFilterCriteria!
                                                          .isNotEmpty)
                                                        Positioned(
                                                          right: 0,
                                                          top: 5,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .redAccent,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            constraints:
                                                                const BoxConstraints(
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
                                            OutlinedButton.icon(
                                              icon: const Icon(Icons.sort),
                                              label: const Text('Tri'),
                                              onPressed: () =>
                                                  _showSortBottomSheet(
                                                      context, servicesNumBloc),
                                              style: OutlinedButton.styleFrom(
                                                  iconColor: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                  side: const BorderSide(
                                                      width: 1.0,
                                                      color: Colors.grey),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          vertical: 5.0),
                                                  minimumSize: const Size(90, 30),
                                                  foregroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .onSurface),
                                            )
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
                      body: Platform.isIOS
                          ? CustomScrollView(
                              slivers: [
                                CupertinoSliverRefreshControl(
                                  onRefresh: () async {
                                    _refreshAll(context);
                                    // previsionsBloc.add(FetchPrevisionsEvent(showIndicator: false));
                                    // servicesNumBloc.add(FetchServicesNumEvent(showIndicator: false));
                                  },
                                ),
                                // FIXME bug refresh affichage
                                // const ExpansionList(dayPrevison: true),
                                const ItemsList(),
                              ],
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                _refreshAll(context);
                                // previsionsBloc.add(FetchPrevisionsEvent(showIndicator: false));
                                // servicesNumBloc.add(FetchServicesNumEvent(showIndicator: false));
                              },
                              child: CustomScrollView(
                                slivers: [
                                  // const ExpansionList(dayPrevison: true),
                                  const ItemsList(),
                                ],
                              ),
                            ),
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.endFloat,
                    floatingActionButton: CustomSearchBar(
                      tabIndexNotifier: ValueNotifier(0),
                    )),
          );
            },
          );

          // }

          // else if (servicesState is ServicesNumLoading) {
          //   return Center(
          //     child: Platform.isIOS
          //         ? CupertinoActivityIndicator(radius: 30)
          //         : CircularProgressIndicator(),
          //   );
          // } else {
          //   return const Center(
          //       child:
          //           Text('Une erreur s\'est produite. Relancez l\'application.'));
          // }
        });
  }



  void _handleTap(BuildContext context) {
    final now = DateTime.now();

    // Vérifie si le tap précédent a eu lieu récemment (moins de 500ms)
    if (_lastTapTime != null && now.difference(_lastTapTime!) < Duration(milliseconds: 300)) {
      _tapCount++;
    } else {
      _tapCount = 1; // Réinitialise le compteur si un tap est effectué après un délai plus long
    }

    // Met à jour le temps du dernier tap
    _lastTapTime = now;

    if (_tapCount == 10) {
      _showHiddenMenu(context);
      _tapCount = 0; // Réinitialise le compteur après avoir montré le menu
    }
  }

  void _showHiddenMenu(BuildContext context){
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (BuildContext context){
          return Container(
            height: 200,
            color: Colors.green,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Menu caché'
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text('Fermer'))

                ],
              ),
            ),
          );
        }

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
      // context.read<SearchBarBloc>().add(CloseSearchBar());
    });
  }

  void _showFilterBottomSheet(BuildContext context, ServicesNumBloc itemsBloc,
      PrevisionsBloc previsionsBloc, int tab) {
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
      // context.read<SearchBarBloc>().add(CloseSearchBar());
    });
  }

  Future<void> _refreshAll(BuildContext context) async {
    final previsionsBloc = context.read<PrevisionsBloc>();
    final servicesNumBloc = context.read<ServicesNumBloc>();

    // Déclenche les événements de mise à jour
    previsionsBloc.add(FetchPrevisionsEvent(showIndicator: false));
    servicesNumBloc.add(FetchServicesNumEvent(showIndicator: false));

    // On attend que les deux blocs aient fini de traiter leurs états
    await Future.wait([
      previsionsBloc.stream.firstWhere(
          (state) => state is PrevisionsLoaded || state is PrevisionsError),
      servicesNumBloc.stream.firstWhere(
          (state) => state is ServicesNumLoaded || state is ServicesNumError),
    ]);
  }
}
