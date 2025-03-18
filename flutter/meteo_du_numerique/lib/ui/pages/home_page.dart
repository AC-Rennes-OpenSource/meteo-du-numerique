import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/bloc/theme_bloc/theme_bloc.dart';

import '../../bloc/previsions_bloc/previsions_bloc.dart';
import '../../bloc/previsions_bloc/previsions_event.dart';
import '../../bloc/services_num_bloc/services_num_bloc.dart';
import '../../bloc/services_num_bloc/services_num_event.dart';
import '../../bloc/services_num_bloc/services_num_state.dart';
import '../../cubit/app_cubit.dart';
import '../decorations/rounded_rect_tab_indicator.dart';
import '../widgets/app_bar.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/expansion_list.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/filter_previsions_bottom_sheet.dart';
import '../widgets/items_list.dart';
import '../widgets/sort_bottom_sheet.dart';
import '../widgets/theme_switch.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final remoteConfig = FirebaseRemoteConfig.instance;
  late TabController _tabController;
  bool _isObserverAdded = false;
  bool _showFeature = true;

  // Variable statique pour gérer le compteur de taps
  static int _tapCount = 0;
  static DateTime? _lastTapTime;

  @override
  void initState() {
    super.initState();
    _refreshAll(context);
    if (!_isObserverAdded) {
      WidgetsBinding.instance.addObserver(this);
      _isObserverAdded = true;
    }
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      // Met à jour l'état ou effectue des actions lorsque l'onglet change
      context.read<AppCubit>().changeTab(_tabController.index);
    });
    context.read<AppCubit>().setTabController(_tabController);
  }

  @override
  void dispose() {
    _tabController.dispose();

    if (_isObserverAdded) {
      WidgetsBinding.instance.removeObserver(this);
      debugPrint("Suppression de l'observateur");
      _isObserverAdded = false;
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
        // debugPrint("App inactive");
        break;
      case AppLifecycleState.paused:
        // debugPrint("App en arrière-plan");
        break;
      case AppLifecycleState.resumed:
        _refreshAll(context);
        debugPrint("[Retour au premier plan] : rechargement données");
        break;
      case AppLifecycleState.detached:
      // debugPrint("App détachée");
      case AppLifecycleState.hidden:
      // debugPrint("App hidden");
    }
  }

  @override
  Widget build(BuildContext context) {
    _showFeature = context.read<ThemeBloc>().state.showPrevision;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? null : Colors.grey.shade200,
      appBar: ThemedAppBar(
        onTitleTap: _handleTap,
        tabBar: !_showFeature
            ? TabBar(
                controller: _tabController,
                overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                splashBorderRadius: const BorderRadius.all(Radius.circular(40)),
                unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
                labelColor: Theme.of(context).colorScheme.onSecondary,
                enableFeedback: true,
                indicatorPadding: const EdgeInsets.all(3),
                indicator: RoundedRectTabIndicator(
                    color: Theme.of(context).colorScheme.primary, radius: 40, borderColor: Colors.transparent, borderWidth: 1),
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
              )
            : null,
      ),
      body: !_showFeature
          ? TabBarView(controller: _tabController, physics: _showFeature ? NeverScrollableScrollPhysics() : null, children: [
              _buildTabContent(context, isPrevisionsTab: false),
              _buildTabContent(context, isPrevisionsTab: true),
            ])
          : _buildTabContent(context, isPrevisionsTab: false),
      floatingActionButton: CustomSearchBar(tabController: _tabController),
    );
  }

  Widget _buildTabContent(BuildContext context, {required bool isPrevisionsTab}) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [_buildSliverAppBar(context, isPrevisionsTab)];
      },
      body: Platform.isIOS ? _buildIOSContent(context, isPrevisionsTab) : _buildAndroidContent(context, isPrevisionsTab),
    );
  }

  Widget _buildIOSContent(BuildContext context, bool isPrevisionsTab) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: () => _refreshAll(context)),
        isPrevisionsTab ? const ExpansionList(dayPrevison: false) : const ItemsList(),
      ],
    );
  }

  Widget _buildAndroidContent(BuildContext context, bool isPrevisionsTab) {
    return RefreshIndicator(
      onRefresh: () => _refreshAll(context),
      child: CustomScrollView(
        slivers: [
          isPrevisionsTab ? const ExpansionList(dayPrevison: false) : const ItemsList(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool isPrevisionsTab) {
    return SliverAppBar(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35))),
      toolbarHeight: 50,
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
      pinned: false,
      floating: true,
      snap: true,
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildFilterButton(context, isPrevisionsTab),
                  const SizedBox(width: 6.0),
                  if (!isPrevisionsTab) _buildSortButton(context),
                ],
              ),
              const ThemeSwitch(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, bool isPrevisionsTab) {
    var servicesNumBloc = context.read<ServicesNumBloc>();
    var previsionsBloc = context.read<PrevisionsBloc>();
    return BlocBuilder<ServicesNumBloc, ServicesNumState>(
      builder: (context, state) {
        return Stack(
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.filter_list),
              label: const Text('Filtres'),
              onPressed: () => _showFilterBottomSheet(context, servicesNumBloc, previsionsBloc, _tabController.index),
              style: OutlinedButton.styleFrom(
                iconColor: Theme.of(context).colorScheme.onSurface,
                side: const BorderSide(width: 1.0, color: Colors.grey),
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                minimumSize: const Size(110, 30),
                foregroundColor: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (servicesNumBloc.currentFilterCriteria!.isNotEmpty && !isPrevisionsTab)
              Positioned(
                right: 0,
                top: 5,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
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
            if (previsionsBloc.currentFilterCriteria.isNotEmpty && isPrevisionsTab)
              Positioned(
                right: 0,
                top: 5,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
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
          ],
        );
      },
    );
  }

  Widget _buildSortButton(BuildContext context) {
    var servicesNumBloc = context.read<ServicesNumBloc>();
    return OutlinedButton.icon(
      icon: const Icon(Icons.sort),
      label: const Text('Tri'),
      onPressed: () => _showSortBottomSheet(context, servicesNumBloc),
      style: OutlinedButton.styleFrom(
        iconColor: Theme.of(context).colorScheme.onSurface,
        side: const BorderSide(width: 1.0, color: Colors.grey),
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        minimumSize: const Size(90, 30),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Future<void> _refreshAll(BuildContext context) async {
    final servicesNumBloc = BlocProvider.of<ServicesNumBloc>(context);
    final previsionsBloc = BlocProvider.of<PrevisionsBloc>(context);
    servicesNumBloc.add(FetchServicesNumEvent(showIndicator: false));
    previsionsBloc.add(FetchPrevisionsEvent(showIndicator: false));
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

  void _showHiddenMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Coins arrondis en haut
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Étire les widgets horizontalement
              children: [
                // Titre
                Text(
                  'Menu des prévisions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),

                // Séparateur
                Divider(thickness: 1, color: Colors.grey[300]),

                // Boutons centrés
                Spacer(), // Ajoute un espace flexible pour centrer verticalement
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Espace égal entre les boutons
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                      ), // Icône pour le bouton "Fermer"
                      label: Text(
                        'Fermer',
                        // style: TextStyle(color: Colors.redAccent), // Couleur du texte
                      ),
                      style: OutlinedButton.styleFrom(
                        // side: BorderSide(color: Colors.redAccent, width: 2), // Bordure rouge
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showFeature = !_showFeature; // Activer ou désactiver la fonctionnalité
                        });
                      },
                      icon: Icon(Icons.check), // Icône pour le bouton "test"
                      label: Text('Activer'),
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.greenAccent, width: 2), // Bordure rouge

                        // backgroundColor: Colors.greenAccent, // Couleur du bouton
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Spacer(), // Ajoute un espace flexible après les boutons

                // Séparateur final
                Divider(thickness: 1, color: Colors.grey[300]),
              ],
            ),
          ),
        );
      },
    );
  }
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
    // context.read<SearchBarBloc>().add(CloseSearchBar());
  });
}
