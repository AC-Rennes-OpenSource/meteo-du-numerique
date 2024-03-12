import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/bloc/items_bloc/services_num_bloc.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_bloc.dart';
import 'package:meteo_du_numerique/bloc/search_bar_bloc/search_bar_bloc.dart';
import 'package:meteo_du_numerique/bloc/search_bar_bloc/search_bar_event.dart';
import 'package:meteo_du_numerique/bloc/search_bar_bloc/search_bar_state.dart';

import '../../bloc/items_bloc/services_num_event.dart';
import '../../bloc/previsions_bloc/previsions_event.dart';

class CustomSearchBar extends StatefulWidget {
  final ValueNotifier<int> tabIndexNotifier;

  const CustomSearchBar({super.key, required this.tabIndexNotifier});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  Map<int, String> searchQueries = {}; // Mémorisation des requêtes de recherche

  @override
  void initState() {
    super.initState();
    widget.tabIndexNotifier.addListener(_onTabIndexChange);
  }

  @override
  void dispose() {
    widget.tabIndexNotifier.removeListener(_onTabIndexChange);
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onTabIndexChange() {
    String? currentQuery = searchQueries[widget.tabIndexNotifier.value];
    if (currentQuery != null && currentQuery.isNotEmpty) {
      // Si une recherche était active sur cet onglet, ouvrez la barre de recherche avec la requête
      context.read<SearchBarBloc>().add(OpenSearchBar());
      _searchController.text = currentQuery;
    } else {
      // Ferme la barre de recherche si aucun texte n'est présent
      context.read<SearchBarBloc>().add(CloseSearchBar());
      _searchController.clear();
    }

    // Assurez-vous de toujours fermer le clavier lors du changement d'onglet
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }

    _triggerSearchUpdate(currentQuery ?? '');
  }

  void _triggerSearchUpdate(String query) {
    searchQueries[widget.tabIndexNotifier.value] = query;
    if (widget.tabIndexNotifier.value == 0) {
      context.read<ServicesNumBloc>().add(SearchItemsEvent(query));
    } else {
      context.read<PrevisionsBloc>().add(SearchPrevisionsEvent(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBarBloc, SearchBarState>(
      builder: (context, state) {
        bool isSearchOpen = state is SearchBarOpened;
        double screenWidth = MediaQuery.of(context).size.width;
        double padding = 16.0;
        double searchWidth = isSearchOpen ? screenWidth - 2 * padding : 52.0;

        return GestureDetector(
          onTap: () {
            if (!isSearchOpen) {
              context.read<SearchBarBloc>().add(OpenSearchBar());
              _focusNode.requestFocus();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            width: searchWidth,
            height: 52.0,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Rechercher...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 16),
                    ),
                    onChanged: _triggerSearchUpdate,
                  ),
                ),
                IconButton(
                  icon: Icon(isSearchOpen || _searchController.text.isNotEmpty ? Icons.close : Icons.search),
                  onPressed: () {
                    if (_searchController.text.isNotEmpty || isSearchOpen) {
                      _searchController.clear();
                      _triggerSearchUpdate('');
                      context.read<SearchBarBloc>().add(CloseSearchBar());
                      _focusNode.unfocus(); // Ferme également le clavier ici
                    } else {
                      context.read<SearchBarBloc>().add(OpenSearchBar());
                      _focusNode.requestFocus();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
