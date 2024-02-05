import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/bloc/items_bloc/items_bloc.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_bloc.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_event.dart';

import '../../bloc/items_bloc/items_event.dart';
import '../../bloc/search_bar_bloc/search_bar_bloc.dart';
import '../../bloc/search_bar_bloc/search_bar_event.dart';
import '../../bloc/search_bar_bloc/search_bar_state.dart';
import '../../bloc/theme_bloc/theme_bloc.dart';

class CustomSearchBar extends StatefulWidget {
  final int tabIndex;

  const CustomSearchBar({super.key, required this.tabIndex});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    final searchBarBloc = BlocProvider.of<SearchBarBloc>(context);
    final itemsBloc = BlocProvider.of<ItemsBloc>(context);
    final previsionsBloc = BlocProvider.of<PrevisionsBloc>(context);

    return BlocBuilder<SearchBarBloc, SearchBarState>(
      builder: (context, state) {
        bool isSearchOpen = state is SearchBarOpened;
        double screenWidth = MediaQuery
            .of(context)
            .size
            .width;
        double padding = 16.0;
        double fabSize = 52.0; // Standard Material FAB size
        double searchWidth = isSearchOpen ? screenWidth - 2 * padding : fabSize;

        return GestureDetector(
          onTap: () {
            if (isSearchOpen) {
              searchBarBloc.add(CloseSearchBar());
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            width: searchWidth,
            height: 52.0,
            decoration: BoxDecoration(
              // color: themeBloc.state.isDarkMode
              //     ? Theme.of(context).colorScheme.onSurface
              //     : Colors.white,
              color: Theme
                  .of(context)
                  .colorScheme
                  .secondaryContainer,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                // color: Theme.of(context).colorScheme.onSurface,
                // color: themeBloc.state.isDarkMode
                //     ? Theme.of(context).colorScheme.onSurface
                // : const Color.fromRGBO(114, 119, 128, 1),
                color: Theme
                    .of(context)
                    .colorScheme
                    .primary,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _searchController,
                    style: TextStyle(
                      color: themeBloc.state.isDarkMode
                          ? Theme
                          .of(context)
                          .colorScheme
                          .onSurface
                          : Theme
                          .of(context)
                          .colorScheme
                          .onSurface,
                    ),
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: 'Rechercher...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 16),
                    ),
                    onChanged: (value) =>
                    {
                      if (widget.tabIndex == 0)
                        {itemsBloc.add(SearchItemsEvent(value))}
                      else
                        {previsionsBloc.add(SearchPrevisionsEvent(value))}
                    },
                    onSubmitted: (value) {
                      // searchBarBloc.add(CloseSearchBar());
                    },
                  ),
                ),
                ClipOval(
                  child: Material(
                    // color: themeBloc.state.isDarkMode
                    //     ? Colors.black
                    //     : const Color.fromRGBO(222, 226, 235, 1),
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    child: InkWell(
                      onTap: () {
                        if (isSearchOpen) {
                          if (_focusNode.hasFocus) {
                            _searchController.clear();
                            // Lors de l'ouverture de la barre de recherche, ajoutez :
                            _focusNode.unfocus();
                          } else {
                            if (_searchController.text.isNotEmpty) {
                              _searchController.clear();
                            }
                          }

                          if (widget.tabIndex == 0) {
                            itemsBloc.add(SearchItemsEvent(''));
                          } else {
                            previsionsBloc.add(SearchPrevisionsEvent(''));
                          }
                          searchBarBloc.add(CloseSearchBar());
                        } else {
                          if (_searchController.text.isNotEmpty) {
                            _searchController.clear();
                            // Le TextField a une valeur
                          } else {
                            searchBarBloc.add(OpenSearchBar());
                            _focusNode.requestFocus();

                            // Le TextField est vide
                          }
                        }
                      },
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: Icon(
                          isSearchOpen ? Icons.close : Icons.search,
                          // color: Theme.of(context).colorScheme.onSurface,
                          // color: themeBloc.state.isDarkMode
                          //     ? Theme.of(context).colorScheme.onSurface
                          //     : const Color.fromRGBO(114, 119, 128, 1),
                          color: Theme
                              .of(context)
                              .colorScheme
                              .onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
