import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meteo_du_numerique/ui/items-list-test.dart';

import '../../cubit/previsions_cubit.dart';
import '../../cubit/previsions_state.dart';
import '../../cubit/services_numeriques_cubit.dart';
import '../../cubit/services_numeriques_state.dart';
import '../../utils.dart';
import '../prevision-list-test.dart';
import '../widgets/theme_switch.dart';

class HomePageTest extends StatefulWidget {
  const HomePageTest({super.key});

  @override
  HomePageTestState createState() => HomePageTestState();
}

class HomePageTestState extends State<HomePageTest> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Charger initialement les services numériques
    context.read<ServicesNumeriquesCubit>().loadServices();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Météo du numérique'),
          bottom: TabBar(
            controller: _tabController,
            onTap: (index) {
              // Charger les données en fonction de l'onglet sélectionné
              switch (index) {
                case 0:
                  context.read<ServicesNumeriquesCubit>().loadServices();
                  break;
                case 1:
                  context.read<PrevisionsCubit>().loadPrevisions();
                  break;
              }
            },
            tabs: const [
              Tab(text: 'Services Numériques'),
              Tab(text: 'Prévisions'),
            ],
          ),
        ),
        body: Column(
          children: [
            LastUpdateWidget(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ServicesNumeriquesTab(),
                  PrevisionsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LastUpdateWidget extends StatelessWidget {
  const LastUpdateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final servicesState = context.watch<ServicesNumeriquesCubit>().state;
    final previsionsState = context.watch<PrevisionsCubit>().state;

    // Utilisation de la méthode utilitaire pour obtenir les dernières mises à jour
    final lastUpdateServices = Utils.getLatestUpdate(
      servicesState.allServices,
      (service) => service.lastUpdate,
    );

    final lastUpdatePrevisions = Utils.getLatestUpdate(
      previsionsState.allPrevisions,
      (prevision) => prevision.lastUpdate,
    );

    // Comparer les deux dates pour obtenir la plus récente
    DateTime? lastUpdate;
    if (lastUpdateServices != null && lastUpdatePrevisions != null) {
      lastUpdate = lastUpdateServices.isAfter(lastUpdatePrevisions) ? lastUpdateServices : lastUpdatePrevisions;
    } else {
      lastUpdate = lastUpdateServices ?? lastUpdatePrevisions; // Prendre l'une ou l'autre si l'autre est null
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Dernière mise à jour: ${lastUpdate != null ? DateFormat('dd/MM/yyyy HH:mm').format(lastUpdate) : ''}',
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

class ServicesNumeriquesTab extends StatelessWidget {
  const ServicesNumeriquesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [_buildSliverAppBar(context)];
      },
      body: Platform.isIOS ? _buildIOSContent(context) : _buildAndroidContent(context),
    );
  }

  Widget _buildIOSContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: () => _refreshAll(context)),
        _buildServicesList(),
      ],
    );
  }

  Widget _buildAndroidContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshAll(context),
      child: CustomScrollView(
        slivers: [
          _buildServicesList(),
        ],
      ),
    );
  }

  Widget _buildServicesList() {
    return BlocBuilder<ServicesNumeriquesCubit, ServicesNumeriquesState>(
      builder: (context, state) {
        return ItemsList(services: state.filteredServices);
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return BlocBuilder<ServicesNumeriquesCubit, ServicesNumeriquesState>(
      builder: (context, state) {
        return SliverAppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
          ),
          toolbarHeight: 50,
          scrolledUnderElevation: 0,
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
          pinned: false,
          floating: true,
          snap: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Implémenter la logique de filtrage
                    },
                    child: Text('Filtrer'),
                  ),
                  const SizedBox(width: 6.0),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ServicesNumeriquesCubit>().toggleSortByName();
                    },
                    child: Text('Trier'),
                  ),
                ],
              ),
              const ThemeSwitch(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _refreshAll(BuildContext context) async {
    await context.read<ServicesNumeriquesCubit>().loadServices();
  }
}

class PrevisionsTab extends StatelessWidget {
  const PrevisionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [_buildSliverAppBar(context)];
      },
      body: Platform.isIOS ? _buildIOSContent(context) : _buildAndroidContent(context),
    );
  }

  Widget _buildIOSContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: () => _refreshAll(context)),
        _buildPrevisionsList(),
      ],
    );
  }

  Widget _buildAndroidContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshAll(context),
      child: CustomScrollView(
        slivers: [
          _buildPrevisionsList(),
        ],
      ),
    );
  }

  Widget _buildServicesList() {
    return BlocBuilder<ServicesNumeriquesCubit, ServicesNumeriquesState>(
      builder: (context, state) {
        return ItemsList(services: state.filteredServices);
      },
    );
  }

  Widget _buildPrevisionsList() {
    return BlocBuilder<PrevisionsCubit, PrevisionsState>(
      builder: (context, state) {
        return PrevisionsList(groupedPrevisions: state.groupedPrevisions);
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return BlocBuilder<PrevisionsCubit, PrevisionsState>(
      builder: (context, state) {
        return SliverAppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
          ),
          toolbarHeight: 50,
          scrolledUnderElevation: 0,
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
          pinned: false,
          floating: true,
          snap: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Implémenter la logique de filtrage
                },
                child: Text('Filtrer'),
              ),
              const ThemeSwitch(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _refreshAll(BuildContext context) async {
    await context.read<PrevisionsCubit>().loadPrevisions();
  }
}
