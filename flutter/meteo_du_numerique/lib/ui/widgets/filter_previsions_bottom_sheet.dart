import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_event.dart';

import '../../bloc/previsions_bloc/previsions_bloc_2.dart';

class FilterPrevisionsBottomSheet extends StatefulWidget {
  final String selectedFilter;
  final List<String> selectedCategories;

  final int tab;

  const FilterPrevisionsBottomSheet(
      {super.key,
      required this.selectedFilter,
      required this.tab,
      required this.selectedCategories});

  @override
  State<FilterPrevisionsBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterPrevisionsBottomSheet> {
  late String _selectedFilter;

  late List<String> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.selectedFilter;
    _selectedCategories = widget.selectedCategories;
  }

  @override
  Widget build(BuildContext context) {
    final previsionsBloc = BlocProvider.of<PrevisionsBloc>(context);

    final List<String> categoryOptions = [
      'Collaboration',
      'Communication',
      'Finance',
      'Pédagogie',
      'Examens et concours',
      'RH',
      'Inclusion',
      'Santé et social',
      'Scolarité',
    ]; // Exemple de catégories

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RadioListTile<String>(
            title: const Text('7 prochains jours'),
            value: 'semaine',
            selected: _selectedFilter == 'semaine',
            groupValue: _selectedFilter,
            onChanged: (value) => _onFilterChanged(value),
          ),
          RadioListTile<String>(
            title: const Text('30 prochains jours'),
            value: 'mois',
            selected: _selectedFilter == 'mois',
            groupValue: _selectedFilter,
            onChanged: (value) => _onFilterChanged(value),
          ),
          RadioListTile<String>(
            title: const Text('Tout'),
            value: 'all',
            selected: _selectedFilter == 'all',
            groupValue: _selectedFilter,
            onChanged: (value) => _onFilterChanged(value),
          ),
          const Padding(
            padding:
                EdgeInsets.only(left: 15, right: 25, top: 15.0, bottom: 15.0),
            child: Divider(),
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: categoryOptions
                .asMap()
                .map((index, category) => MapEntry(
                    index,
                    ChoiceChip(
                      selectedColor: _getChipColor(index),
                      checkmarkColor: Colors.white,
                      backgroundColor: _selectedCategories.contains(category)
                          ? _getChipColor(index)
                          : _getChipColor(index).withOpacity(0.1),
                      label: Text(
                        category,
                        style: TextStyle(
                            fontSize: 11,
                            color: _selectedCategories.contains(category)
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface),
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: _getChipColor(index), width: 2),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      selected: _selectedCategories.contains(category),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedCategories.add(category);
                          } else {
                            _selectedCategories.remove(category);
                          }
                        });
                      },
                    )))
                .values
                .toList(),
          ),
          const Padding(
            padding:
                EdgeInsets.only(left: 15, right: 25, top: 15.0, bottom: 25.0),
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
                      foregroundColor: _selectedFilter == 'all' &&
                              _selectedCategories.isEmpty
                          ? Colors.grey
                          : Theme.of(context).colorScheme.onSurface),
                  icon: const Icon(Icons.close),
                  label: const Text("Réinitialiser"),
                  onPressed: () {
                    setState(() {
                      _selectedFilter = 'all'; // Réinitialiser la sélection
                      _selectedCategories = []; // Réinitialiser la sélection
                    });
                  },
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: Colors.grey),
                  ),
                  onPressed: () {
                    previsionsBloc.add(FilterPrevisionsEvent(
                        _selectedCategories, _selectedFilter));
                    Navigator.pop(context);
                  },
                  child: const Text("Appliquer"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getChipColor(int index) {
    // TODO à modifier. Retourne une couleur différente en fonction de l'index
    final colors = [
      // 'Collaboration',
      // 'Communication',
      // 'Finance',
      // 'Pédagogie',
      // 'Examens et concours',
      // 'RH',
      // 'Inclusion',
      // 'Santé et social',
      // 'Scolarité',
      const Color(0xff63BAAB),
      const Color(0xFFC7A213),
      const Color(0xffE197A4),
      const Color(0xffC25452),
      const Color(0xff28619A),
      const Color(0xFFD17010),
      const Color(0xff00B872),
      Colors.brown,
      Colors.blue,
    ];
    return colors[index % colors.length];
  }

  void _onFilterChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedFilter = value;
      });
    }
  }
}
