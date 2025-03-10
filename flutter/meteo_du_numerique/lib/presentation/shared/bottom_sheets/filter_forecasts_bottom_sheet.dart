import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/blocs/forecasts/forecasts_bloc.dart';
import '../../../domain/blocs/forecasts/forecasts_event.dart';
import '../../../domain/blocs/forecasts/forecasts_state.dart';

class FilterForecastsBottomSheet extends StatefulWidget {
  final List<String> selectedCategories;
  final String? selectedFilter;
  final int tab;

  const FilterForecastsBottomSheet({
    super.key,
    required this.selectedCategories,
    this.selectedFilter,
    required this.tab,
  });

  @override
  State<FilterForecastsBottomSheet> createState() => _FilterForecastsBottomSheetState();
}

class _FilterForecastsBottomSheetState extends State<FilterForecastsBottomSheet> {
  List<String> selectedCategories = [];
  String selectedPeriod = 'all';

  @override
  void initState() {
    super.initState();
    selectedCategories = List.from(widget.selectedCategories);
    selectedPeriod = widget.selectedFilter ?? 'all';
  }
  
  Color _getChipColor(int index) {
    final colors = [
      const Color(0xff63BAAB),
      const Color(0xFFC7A213),
      const Color(0xffE197A4),
      const Color(0xffC25452),
      const Color(0xff28619A),
      const Color(0xFFD17010),
      const Color(0xff00B872),
      const Color(0xFF795548),
      const Color(0xFF2196f3),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final forecastsBloc = BlocProvider.of<ForecastsBloc>(context);

    return BlocBuilder<ForecastsBloc, ForecastsState>(
      builder: (context, state) {
        if (state is ForecastsLoaded) {
          final categories = [
            {'id': '1', 'name': 'Collaboration', 'icon': Icons.people, 'color': const Color(0xff63BAAB)},
            {'id': '2', 'name': 'RH', 'icon': Icons.person, 'color': const Color(0xFFC7A213)},
            {'id': '22', 'name': 'Finance', 'icon': Icons.attach_money, 'color': const Color(0xffE197A4)},
            {'id': '34', 'name': 'Pédagogie', 'icon': Icons.school, 'color': const Color(0xffC25452)},
            {'id': '35', 'name': 'Examens et concours', 'icon': Icons.assignment, 'color': const Color(0xff28619A)},
            {'id': '6', 'name': 'Inclusion', 'icon': Icons.accessibility, 'color': const Color(0xFFD17010)},
            {'id': '27', 'name': 'Scolarité', 'icon': Icons.menu_book, 'color': const Color(0xff00B872)},
            {'id': '8', 'name': 'Communication', 'icon': Icons.message, 'color': const Color(0xFF795548)},
            {'id': '9', 'name': 'Santé et social', 'icon': Icons.favorite, 'color': const Color(0xFF2196f3)},
          ];

          final periods = [
            {'id': 'semaine', 'name': '7 prochains jours'},
            {'id': 'mois', 'name': '30 prochains jours'},
            {'id': 'all', 'name': 'Tout'},
          ];
          
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SingleChildScrollView(
              child: Column(

                mainAxisSize: MainAxisSize.min,
                children: [
                ListView.builder(
                  padding: EdgeInsets.zero, // Supprime le padding par défaut
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: periods.length,
                  itemBuilder: (context, index) {
                    final period = periods[index];

                    return RadioListTile<String>(
                      title: Text(period['name'] as String),
                      value: period['id'] as String,
                      groupValue: selectedPeriod,
                      onChanged: (value) {
                        setState(() {
                          selectedPeriod = value!;
                        });
                      },
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15, right: 25, bottom: 20.0),
                  child: Divider(),
                ),


                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: categories
                    .asMap()
                    .map((index, category) => MapEntry(
                      index,
                      ChoiceChip(
                        selectedColor: _getChipColor(index),
                        checkmarkColor: Colors.white,
                        backgroundColor: selectedCategories.contains(category['id'])
                          ? _getChipColor(index)
                          : _getChipColor(index).withOpacity(0.1),
                        label: Text(
                          category['name'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: selectedCategories.contains(category['id'])
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: _getChipColor(index), width: 2),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        selected: selectedCategories.contains(category['id']),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              selectedCategories.add(category['id'] as String);
                            } else {
                              selectedCategories.remove(category['id']);
                            }
                          });
                        },
                      )
                    ))
                    .values
                    .toList(),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15, right: 25, bottom: 15.0, top: 15.0),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        iconColor: Theme.of(context).colorScheme.onSurface,
                        side: const BorderSide(width: 1.0, color: Colors.grey),
                        foregroundColor: selectedPeriod == 'all' && selectedCategories.isEmpty
                            ? Colors.grey
                            : Theme.of(context).colorScheme.onSurface
                      ),
                      icon: const Icon(Icons.close),
                      label: const Text("Réinitialiser"),
                      onPressed: () {
                        setState(() {
                          selectedPeriod = 'all';
                          selectedCategories = [];
                        });
                      },
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.onSurface,
                        side: const BorderSide(width: 1.0, color: Colors.grey),
                      ),
                      onPressed: () {
                        forecastsBloc.add(FilterForecastsEvent(selectedCategories, selectedPeriod));
                        Navigator.pop(context);
                      },
                      child: const Text("Appliquer"),
                    ),
                  ],
                ),
                )],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}