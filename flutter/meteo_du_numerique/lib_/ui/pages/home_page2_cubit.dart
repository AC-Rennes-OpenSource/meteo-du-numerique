import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/items_bloc/services_num_bloc.dart';
import '../../bloc/items_bloc/services_num_event.dart';
import '../../bloc/items_bloc/services_num_state.dart';
import '../../bloc/previsions_bloc/previsions_bloc_2.dart';
import '../../bloc/previsions_bloc/previsions_event.dart';
import '../../cubit/app_cubit.dart';
import '../decorations/rounded_rect_tab_indicator.dart';
import '../widgets/app_bar.dart';
import '../widgets/custom_search_bar_2.dart';
import '../widgets/expansion_list.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/filter_previsions_bottom_sheet.dart';
import '../widgets/items_list.dart';
import '../widgets/sort_bottom_sheet.dart';
import '../widgets/theme_switch.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  HomePage2State createState() => HomePage2State();
}

class HomePage2State extends State<HomePage2> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final remoteConfig = FirebaseRemoteConfig.instance;
  late TabController _tabController;
  bool _isObserverAdded = false;

  @override
  void initState() {
    super.initState();
    _refreshAll(context);
    if (!_isObserverAdded) {
      WidgetsBinding.instance.addObserver(this);
      print("Ajout de l'observateur");
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
      print("Suppression de l'observateur");
      _isObserverAdded = false;
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
        print("App inactive");
        break;
      case AppLifecycleState.paused:
        print("App en arrière-plan");
        break;
      case AppLifecycleState.resumed:
        _refreshAll(context);
        print("App au premier plan");
        break;
      case AppLifecycleState.detached:
        print("App détachée");
      case AppLifecycleState.hidden:
        print("App hidden");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? null : Colors.grey.shade200,
      appBar: ThemedAppBar(
        onTitleTap: _handleTap,
        tabBar: !remoteConfig.getBool("show_previsions")
            ? TabBar(
                controller: _tabController,
                overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                splashBorderRadius: const BorderRadius.all(Radius.circular(40)),
                unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
                labelColor: Theme.of(context).colorScheme.onSecondary,
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
              )
            : null,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent(context, isPrevisionsTab: false),
          _buildTabContent(context, isPrevisionsTab: true),
        ],
      ),
      floatingActionButton: CustomSearchBar(tabController: _tabController),
    );
  }

  Widget _buildTabContent(BuildContext context, {required bool isPrevisionsTab}) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [_buildSliverAppBar(context, isPrevisionsTab)];
      },
      body:
          Platform.isIOS ? _buildIOSContent(context, isPrevisionsTab) : _buildAndroidContent(context, isPrevisionsTab),
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
    return BlocBuilder<ServicesNumBloc, ServicesNumState>(
      builder: (context, state) {
        DateTime? displayedLastUpdate;
        if (state is ServicesNumLoaded && state.lastUpdate != null) {
          displayedLastUpdate = state.lastUpdate;
        }

        return SliverAppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35))),
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
      },
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
            // TODO badge pour PREVISIONS if (PrevisionsBloc.currentFilterCriteria!.isNotEmpty && !isPrevisionsTab)
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
    print("--------refresh");
    final servicesNumBloc = BlocProvider.of<ServicesNumBloc>(context);
    final previsionsBloc = BlocProvider.of<PrevisionsBloc>(context);
    servicesNumBloc.add(FetchServicesNumEvent(showIndicator: false));
    previsionsBloc.add(FetchPrevisionsEvent(showIndicator: false));
  }

  void _handleTap(BuildContext context) {
    print("tap");
    // Implement your tap handling logic here
  }
}

void _updateTabIndex(int index) {
  print(index);
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
