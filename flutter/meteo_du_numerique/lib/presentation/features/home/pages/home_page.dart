import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/presentation/theme/theme_event.dart';

import '../../../../domain/blocs/digital_services/digital_services_bloc.dart';
import '../../../../domain/blocs/digital_services/digital_services_event.dart';
import '../../../../domain/blocs/digital_services/digital_services_state.dart';
import '../../../../domain/blocs/forecasts/forecasts_bloc.dart';
import '../../../../domain/blocs/forecasts/forecasts_event.dart';
import '../../../../domain/blocs/theme/theme_bloc.dart';
import '../../../../domain/cubits/app_cubit.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../common/widgets/search_bar/custom_search_bar.dart';
import '../../../common/widgets/theme_switch/theme_switch.dart';
import '../../../shared/bottom_sheets/filter_bottom_sheet.dart';
import '../../../shared/bottom_sheets/filter_forecasts_bottom_sheet.dart';
import '../../../shared/bottom_sheets/sort_bottom_sheet.dart';
import '../../../shared/decorations/rounded_rect_tab_indicator.dart';
import '../widgets/forecasts_list.dart';
import '../widgets/services_list.dart';

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

  // Variable for managing tap counter
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
      // Update the state when tab changes
      context.read<AppCubit>().changeTab(_tabController.index);
    });
    context.read<AppCubit>().setTabController(_tabController);
  }

  @override
  void dispose() {
    _tabController.dispose();

    if (_isObserverAdded) {
      WidgetsBinding.instance.removeObserver(this);
      _isObserverAdded = false;
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _refreshAll(context);

      // Vérifier si les prévisions sont désactivées et forcer l'onglet Services si nécessaire
      final showForecasts = context.read<ThemeBloc>().state.showForecasts;
      if (!showForecasts && _tabController.index == 1) {
        _tabController.animateTo(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _showFeature = context.watch<ThemeBloc>().state.showForecasts;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? null : Colors.grey.shade200,
      appBar: ThemedAppBar(
        onTitleTap: _handleTap,
        tabBar: _showFeature
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
                      'Aujourd\'hui',
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
      body: _showFeature
          ? TabBarView(
              controller: _tabController,
              physics: const ClampingScrollPhysics(), // Pour éviter les rebonds mais permettre le swipe
              children: [
                _buildTabContent(context, isForecasts: false),
                _buildTabContent(context, isForecasts: true),
              ]
            )
          : _buildTabContent(context, isForecasts: false), // Si les prévisions sont désactivées, montrer uniquement l'onglet "Aujourd'hui"
      floatingActionButton: CustomSearchBar(tabController: _tabController),
    );
  }

  Widget _buildTabContent(BuildContext context, {required bool isForecasts}) {
    return NestedScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [_buildSliverAppBar(context, isForecasts)];
      },
      body: Platform.isIOS ? _buildIOSContent(context, isForecasts) : _buildAndroidContent(context, isForecasts),
    );
  }

  Widget _buildIOSContent(BuildContext context, bool isForecasts) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: () => _refreshAll(context)),
        isForecasts ? const ForecastsList() : const ServicesList(),
      ],
    );
  }

  Widget _buildAndroidContent(BuildContext context, bool isForecasts) {
    return RefreshIndicator(
      onRefresh: () => _refreshAll(context),
      child: CustomScrollView(
        slivers: [
          isForecasts ? const ForecastsList() : const ServicesList(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool isForecasts) {
    return SliverAppBar(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35))),
      toolbarHeight: 50,
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black.withOpacity(0.9) : Colors.white.withOpacity(0.9),
      pinned: false,
      floating: true,
      snap: true, 
      primary: true,
      expandedHeight: 0,
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildFilterButton(context, isForecasts),
                  const SizedBox(width: 6.0),
                  if (!isForecasts) _buildSortButton(context),
                ],
              ),
              const ThemeSwitch(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, bool isForecasts) {
    var servicesBloc = context.read<DigitalServicesBloc>();
    var forecastsBloc = context.read<ForecastsBloc>();
    return BlocBuilder<DigitalServicesBloc, DigitalServicesState>(
      builder: (context, state) {
        return Stack(
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.filter_list),
              label: const Text('Filtres'),
              onPressed: () => _showFilterBottomSheet(context, servicesBloc, forecastsBloc, _tabController.index),
              style: OutlinedButton.styleFrom(
                iconColor: Theme.of(context).colorScheme.onSurface,
                side: const BorderSide(width: 1.0, color: Colors.grey),
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                minimumSize: const Size(110, 30),
                foregroundColor: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (((servicesBloc.currentFilterCriteria?.isNotEmpty ?? false) || 
                (servicesBloc.currentCategoryFilters?.isNotEmpty ?? false)) && !isForecasts)
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
            if ((forecastsBloc.currentFilterCriteria?.isNotEmpty ?? false) && isForecasts)
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
    var servicesBloc = context.read<DigitalServicesBloc>();
    return OutlinedButton.icon(
      icon: const Icon(Icons.sort),
      label: const Text('Trier'),
      onPressed: () => _showSortBottomSheet(context, servicesBloc),
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
    final servicesBloc = BlocProvider.of<DigitalServicesBloc>(context);
    final forecastsBloc = BlocProvider.of<ForecastsBloc>(context);
    servicesBloc.add(FetchDigitalServicesEvent(showIndicator: false));
    forecastsBloc.add(FetchForecastsEvent(showIndicator: false));
  }

  void _handleTap(BuildContext context) {
    final now = DateTime.now();

    // Check if the previous tap was recently (less than 300ms)
    if (_lastTapTime != null && now.difference(_lastTapTime!) < Duration(milliseconds: 300)) {
      _tapCount++;
    } else {
      _tapCount = 1; // Reset counter for longer delays
    }

    // Update last tap time
    _lastTapTime = now;

    if (_tapCount == 10) {
      _showHiddenMenu(context);
      _tapCount = 0; // Reset counter after showing the menu
    }
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si les prévisions sont désactivées, forcer l'onglet Services
    final showForecasts = context.read<ThemeBloc>().state.showForecasts;
    if (!showForecasts && _tabController.index == 1) {
      _tabController.animateTo(0);

      // Mise à jour du state pour informer l'AppCubit du changement d'onglet
      context.read<AppCubit>().changeTab(0);

    }
  }

  void _showHiddenMenu(BuildContext context) {
    final themeBloc = context.read<ThemeBloc>();

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Menu des prévisions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Divider(thickness: 1, color: Colors.grey[300]),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close),
                      label: Text('Fermer'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        themeBloc.add(ThemeEvent.toggleForecastsVisibility);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.check),
                      label: Text(themeBloc.state.showForecasts ? 'Désactiver' : 'Activer'),
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.greenAccent, width: 2),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Divider(thickness: 1, color: Colors.grey[300]),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _showSortBottomSheet(BuildContext context, DigitalServicesBloc servicesBloc) {
  FocusScope.of(context).unfocus();
  String? currentSorting = servicesBloc.currentSortCriteria;
  String? currentOrder = servicesBloc.currentSortOrder;

  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return SortBottomSheet(
        servicesBloc: servicesBloc,
        selectedSorting: currentSorting,
        selectedOrder: currentOrder,
      );
    },
  );
}

void _showFilterBottomSheet(BuildContext context, DigitalServicesBloc servicesBloc, ForecastsBloc forecastsBloc, int tab) {
  FocusScope.of(context).unfocus();

  showModalBottomSheet(
    scrollControlDisabledMaxHeightRatio: 0.75,
    context: context,
    builder: (BuildContext bc) {
      return tab == 0
          ? FilterBottomSheet(
              selectedFilters: servicesBloc.currentFilters,
              selectedCategories: servicesBloc.currentCategoryFilters ?? [],
              tab: tab,
            )
          : FilterForecastsBottomSheet(
              selectedFilter: forecastsBloc.currentPeriode,
              tab: tab,
              selectedCategories: forecastsBloc.currentFilterCriteria ?? [],
            );
    },
  );
}
