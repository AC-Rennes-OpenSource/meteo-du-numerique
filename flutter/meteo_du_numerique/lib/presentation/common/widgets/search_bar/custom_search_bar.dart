import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/blocs/digital_services/digital_services_bloc.dart';
import '../../../../domain/blocs/digital_services/digital_services_event.dart';
import '../../../../domain/blocs/forecasts/forecasts_bloc.dart';
import '../../../../domain/blocs/forecasts/forecasts_event.dart';
import '../../../../domain/cubits/app_cubit.dart';
import '../../../../domain/cubits/search_cubit.dart';

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
  Map<int, String> searchQueries = {}; // Cache search queries per tab

  @override
  void initState() {
    super.initState();
    _tabController = widget.tabController;
    _tabController.addListener(_onTabChange);
    _tabController.animation!.addListener(_onTabChangeScroll);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChange);
    _tabController.animation!.removeListener(_onTabChangeScroll);
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChange() {
    if (_tabController.indexIsChanging) {
      if (context.read<SearchCubit>().state is ClearedAll) {
        searchQueries[0] = '';
        searchQueries[1] = '';
        _searchController.clear();
        _focusNode.unfocus();
      }
      _updateSearchBar(_tabController.index);
    }
  }

  void _onTabChangeScroll() {
    final int newIndex = _tabController.index;
    if (newIndex != context.read<AppCubit>().state.tabIndex) {
      if (context.read<SearchCubit>().state is ClearedAll) {
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
      context.read<SearchCubit>().openSearchBar();
      _searchController.text = currentQuery;
      _focusNode.requestFocus();
    } else {
      context.read<SearchCubit>().closeSearchBar();
      _searchController.clear();
      _focusNode.unfocus();
    }
  }

  void _triggerSearchUpdate(String query, int currentTabIndex) {
    searchQueries[currentTabIndex] = query;

    if (currentTabIndex == 0) {
      context.read<DigitalServicesBloc>().add(SearchDigitalServicesEvent(query));
    }
    if (currentTabIndex == 1) {
      context.read<ForecastsBloc>().add(SearchForecastsEvent(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchCubit, SearchState>(listener: (context, state) {
      if (state is ClearedAll) {
        searchQueries[0] = '';
        searchQueries[1] = '';
        _searchController.clear();
        _focusNode.unfocus();
        _triggerSearchUpdate('', _tabController.index);
      }

      if (state is SearchQueryUpdated) {
        _searchController.text = state.query;
      }
      if (state is SearchClosed) {
        _searchController.clear();
      }
    }, child: BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        bool isSearchOpen = state is SearchOpened;
        double screenWidth = MediaQuery.of(context).size.width;
        double padding = 16.0;
        double searchWidth = isSearchOpen ? screenWidth - 2 * padding : 52.0;

        return GestureDetector(
          onTap: () {
            if (!isSearchOpen) {
              context.read<SearchCubit>().openSearchBar();
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
                  icon: Icon(state is SearchOpened || _searchController.text.isNotEmpty ? Icons.close : Icons.search),
                  onPressed: () {
                    if (_searchController.text.isNotEmpty && isSearchOpen) {
                      _searchController.clear();
                      _triggerSearchUpdate('', _tabController.index);
                      context.read<SearchCubit>().closeSearchBar();
                      _focusNode.unfocus(); // Close keyboard
                    } else if (_searchController.text.isEmpty && isSearchOpen) {
                      context.read<SearchCubit>().closeSearchBar();
                      _focusNode.unfocus();
                    } else {
                      context.read<SearchCubit>().openSearchBar();
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
