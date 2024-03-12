import 'package:diacritic/diacritic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'data_model.dart';
import 'repository.dart';
import 'service_card_widget.dart';

class HomePageWeb extends StatefulWidget {
  const HomePageWeb({super.key});

  @override
  State<HomePageWeb> createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  late List<Service> services;

  DateTime? lastUpdate;
  final List<Service> _services = <Service>[];
  List<Service> _servicesDisplay = <Service>[];
  bool toggle = false;

  bool fav = false;
  bool fav2 = false;
  bool fav3 = false;
  bool fav4 = false;
  bool disableSort = false;

  @override
  void initState() {
    super.initState();

    initializeDateFormatting();

    fetchServices().then((value) {
      setState(() {
        // _isLoading = false;
        _services.addAll(value);
        // todo filter
        // final filtered = _services
        //     .where((service) => service.libelle.contains("COLIBRIS"))
        //     .toList();
        // _servicesDisplay = filtered;
        _servicesDisplay = _services;

        _servicesDisplay = sortAll(false);

        // todo

        lastUpdate = _services.map((e) => e.lastUpdate).reduce((min, e) => e.isAfter(min) ? e : min);
      });
    });
  }

  String lastUpdateString(DateTime lastUpdate) {
    String form = DateFormat("dd MMMM yyyy", "fr_FR").format(lastUpdate);
    String hour =
        "${DateFormat("H").format(lastUpdate.add(const Duration(hours: 2)))}h${DateFormat("mm").format(lastUpdate)}";
    return "Dernière mise à jour le $form à $hour";
  }

  List<Service> filtered(int value) {
    var filtered = _services.where((service) => service.qualiteDeServiceId == value).toList();
    filtered
        .sort((a, b) => removeDiacritics(a.libelle.toLowerCase()).compareTo(removeDiacritics(b.libelle.toLowerCase())));
    return filtered;
  }

  List<Service> sortAll(bool inverse) {
    var critic1 = _services.where((service) => service.qualiteDeServiceId == 1).toList();
    critic1
        .sort((a, b) => removeDiacritics(a.libelle.toLowerCase()).compareTo(removeDiacritics(b.libelle.toLowerCase())));
    var critic2 = _services.where((service) => service.qualiteDeServiceId == 2).toList();
    critic2
        .sort((a, b) => removeDiacritics(a.libelle.toLowerCase()).compareTo(removeDiacritics(b.libelle.toLowerCase())));
    var critic3 = _services.where((service) => service.qualiteDeServiceId == 3).toList();
    critic3
        .sort((a, b) => removeDiacritics(a.libelle.toLowerCase()).compareTo(removeDiacritics(b.libelle.toLowerCase())));
    if (inverse) {
      critic1.addAll(critic2);
      critic1.addAll(critic3);
      return critic1;
    } else {
      critic3.addAll(critic2);
      critic3.addAll(critic1);
      return critic3;
    }
  }

  List<bool> isSelected = <bool>[false, false, false];

  //todo rst

  bool isSearchOpen = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void toggleSearch() {
    setState(() {
      isSearchOpen = !isSearchOpen;
    });
    if (isSearchOpen) {
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          CombinedSliverAppBar(lastUpdate: lastUpdate),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: AlignedGridView.extent(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 150, top: 10),
                maxCrossAxisExtent: 550,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                itemCount: _servicesDisplay.length,
                itemBuilder: (BuildContext context, int index) => ServiceCardWidget(service: _servicesDisplay[index]),
              ),
            ),
            // ),
          ),
        ],
      ),
    );
  }
}

class CombinedSliverAppBar extends StatefulWidget {
  final DateTime? lastUpdate;

  const CombinedSliverAppBar({super.key, required this.lastUpdate});

  static const List<Widget> icons = <Widget>[
    Icon(Icons.sunny, color: Color(0xff04dc9a)),
    Icon(CupertinoIcons.umbrella_fill, color: Color(0xffdd9e51)),
    Icon(Icons.flash_on, color: Color(0xffff3d71)),
  ];

  @override
  State<CombinedSliverAppBar> createState() => _CombinedSliverAppBarState();
}

class _CombinedSliverAppBarState extends State<CombinedSliverAppBar> {
  final double appBarHeight = 240.0;

  List<bool> isSelected = <bool>[false, false, false];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Déterminez si nous sommes sur un petit écran
    bool isSmallScreen = screenWidth < 800;

    return SliverAppBar(
      backgroundColor: Colors.white,
      expandedHeight: appBarHeight + 60,
      pinned: true,
      floating: false,
      snap: false,
      scrolledUnderElevation: 0,
      flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        bool isCollapsed = constraints.biggest.height <= kToolbarHeight + 10;
        return FlexibleSpaceBar(
          titlePadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          centerTitle: true,
          collapseMode: CollapseMode.parallax,
          title: isCollapsed ? Image.asset('images/icon-meteo-modified-large2.png') : null,
          background: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: appBarHeight,
                  child: Row(
                    children: [
                      Expanded(
                        flex: isSmallScreen ? 1 : 3,
                        child: isSmallScreen
                            ? const SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.only(left: 0, top: 40, bottom: 30, right: 50),
                                child: Image.asset('images/logo_academie.jpg'),
                              ),
                      ),
                      Expanded(
                        flex: isSmallScreen ? 10 : 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('images/icon-meteo-modified-large2.png', height: 90),
                            const SizedBox(height: 8),
                            Text('Météo du numérique',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: isSmallScreen ? 30 : 40, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            isSmallScreen
                                ? const SizedBox.shrink()
                                : const Text(
                                    textAlign: TextAlign.center,
                                    'Retrouvez en continu la météo des principaux services numériques de l’académie.',
                                    style: TextStyle(fontSize: 16, color: Colors.black54)),
                            const SizedBox(height: 12),
                            Text(widget.lastUpdate != null ? lastUpdateString(widget.lastUpdate!) : "",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 12 : 16,
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: isSmallScreen ? 1 : 3,
                        child: isSmallScreen
                            ? const SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.all(50),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Également disponible sur Google Play.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14, color: Colors.black54)),
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child: Image.asset('images/qrcode.png'),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                // Deuxième partie (Contenu de MySliverAppBar)
                const Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.5),
    );
  }

  String lastUpdateString(DateTime lastUpdate) {
    String form = DateFormat("dd MMMM yyyy", "fr_FR").format(lastUpdate);
    String hour =
        "${DateFormat("H").format(lastUpdate.add(const Duration(hours: 1)))}h${DateFormat("mm").format(lastUpdate)}";
    return "Dernière mise à jour le $form à $hour";
  }
}
