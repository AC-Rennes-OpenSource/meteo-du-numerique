import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/bloc/search_bar_bloc/search_bar_bloc.dart';
import 'package:meteo_du_numerique/bloc/search_bar_bloc/search_bar_event.dart';
import 'package:meteo_du_numerique/bloc/search_bar_bloc/search_bar_state.dart';

import '../../bloc/services_num_bloc/services_num_bloc.dart';
import '../../bloc/services_num_bloc/services_num_event.dart';
import '../../cubit/app_cubit.dart';

class CustomSearchBar extends StatefulWidget {
  final TabController tabController;

  static void closeKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  const CustomSearchBar({super.key, required this.tabController});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late final TabController _tabController;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  Map<int, String> searchQueries = {}; // Mémorisation des requêtes de recherche

  @override
  void initState() {
    super.initState();
    // widget.tabIndexNotifier.addListener(_onTabIndexChange);
    _tabController = widget.tabController;
    _tabController.addListener(_onTabChange);
    _tabController.animation!.addListener(_onTabChangeScroll);
  }

  @override
  void dispose() {
    // widget.tabIndexNotifier.removeListener(_onTabIndexChange);
    _tabController.removeListener(_onTabChange);
    _tabController.animation!.removeListener(_onTabChangeScroll);
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChange() {
    if (_tabController.indexIsChanging) {
      if (context.read<SearchBarBloc>().state is ClearedAll) {
        searchQueries[0] = '';
        searchQueries[1] = '';
        _searchController.clear();
        _focusNode.unfocus();
        // _triggerSearchUpdate('');
      }
      _updateSearchBar(_tabController.index);
    }
  }

  void _onTabChangeScroll() {
    final int newIndex = _tabController.index;
    if (newIndex != context.read<AppCubit>().state.tabIndex) {
      if (context.read<SearchBarBloc>().state is ClearedAll) {
        searchQueries[0] = '';
        searchQueries[1] = '';
        _searchController.clear();
        _focusNode.unfocus();
        _triggerSearchUpdate('', newIndex);
      }
      _updateSearchBar(newIndex);
    }
  }

  void _updateSearchBar(int tabIndex) {
    String? currentQuery = searchQueries[tabIndex];
    if (currentQuery != null && currentQuery.isNotEmpty) {
      context.read<SearchBarBloc>().add(OpenSearchBar());
      _searchController.text = currentQuery;
      _focusNode.requestFocus();
    } else {
      context.read<SearchBarBloc>().add(CloseSearchBar());
      _searchController.clear();
      _focusNode.unfocus();
    }
    // _triggerSearchUpdate(currentQuery ?? '', tabIndex);
  }

  void _triggerSearchUpdate(String query, int currentTabIndex) {
    searchQueries[currentTabIndex] = query;

    if (currentTabIndex == 0) {
      context.read<ServicesNumBloc>().add(SearchItemsEvent(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBarBloc, SearchBarState>(listener: (context, state) {
      if (state is ClearedAll) {
        searchQueries[0] = '';
        searchQueries[1] = '';
        _searchController.clear();
        _focusNode.unfocus();
        _triggerSearchUpdate('', _tabController.index);
      }

      if (state is SearchBarQueryUpdated) {
        _searchController.text = state.query;
      }
      if (state is SearchBarClosed) {
        _searchController.clear();
      }
    }, child: BlocBuilder<SearchBarBloc, SearchBarState>(
      builder: (context, state) {
        bool isSearchOpen = state is SearchBarOpened;
        double screenWidth = MediaQuery.of(context).size.width;
        double padding = 16.0;
        double searchWidth = isSearchOpen ? screenWidth - 2 * padding : 52.0;
        // Your UI building logic goes here
        return GestureDetector(
          onTap: () {
            if (!isSearchOpen) {
              context.read<SearchBarBloc>().add(OpenSearchBar());
              _focusNode.requestFocus();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
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
                    // textInputAction: TextInputAction.search,
                    focusNode: _focusNode,
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Rechercher...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 16),
                    ),
                    onChanged: (value) {
                      _triggerSearchUpdate(value, _tabController.index);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(state is SearchBarOpened || _searchController.text.isNotEmpty ? Icons.close : Icons.search),
                  onPressed: () {
                    if (_searchController.text.isNotEmpty && isSearchOpen) {
                      _searchController.clear();
                      _triggerSearchUpdate('', _tabController.index);
                      context.read<SearchBarBloc>().add(CloseSearchBar());
                      _focusNode.unfocus(); // Ferme le clavier
                    } else if (_searchController.text.isEmpty && isSearchOpen) {
                      context.read<SearchBarBloc>().add(CloseSearchBar());
                      _focusNode.unfocus();
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
    ));
  }
}
