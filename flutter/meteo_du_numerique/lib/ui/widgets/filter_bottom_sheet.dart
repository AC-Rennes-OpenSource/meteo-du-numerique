import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/items_bloc/items_bloc.dart';
import '../../bloc/items_bloc/items_event.dart';
import '../../bloc/previsions_bloc/previsions_bloc.dart';

// todo rst : composant unique pour les deux tabs??
class FilterBottomSheet extends StatefulWidget {
  final List<String> selectedFilters;

  final int tab;

  const FilterBottomSheet({super.key, required this.selectedFilters, required this.tab});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late List<String> _selectedFilters = [];

  @override
  void initState() {
    super.initState();
    _selectedFilters = widget.selectedFilters;
  }

  @override
  Widget build(BuildContext context) {
    final itemsBloc = BlocProvider.of<ItemsBloc>(context);
    final previsionsBloc = BlocProvider.of<PrevisionsBloc>(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CheckboxListTile(
            title: const Text("Dysfonctionnement bloquant"),
            value: _selectedFilters.contains('dysfonctionnement bloquant'),
            onChanged: (bool? value) {
              _onFilterChanged('dysfonctionnement bloquant', value!);
            },
          ),
          CheckboxListTile(
            title: const Text('Perturbations'),
            value: _selectedFilters.contains('perturbations'),
            onChanged: (bool? value) {
              _onFilterChanged('perturbations', value!);
            },
          ),
          CheckboxListTile(
            title: const Text('Fonctionnement habituel'),
            value: _selectedFilters.contains('fonctionnement habituel'),
            onChanged: (bool? value) {
              _onFilterChanged('fonctionnement habituel', value!);
            },
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15, right: 25, top: 15.0, bottom: 15.0),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(width: 1.0, color: Colors.grey),
                      foregroundColor:
                      _selectedFilters.isEmpty ? Colors.grey : Theme
                          .of(context)
                          .colorScheme
                          .onSurface),
                  icon: const Icon(Icons.close),
                  label: const Text("Réinitialiser"),
                  onPressed: _selectedFilters.isNotEmpty
                      ? () {
                    setState(() {
                      _selectedFilters.clear();
                    });
                    // Navigator.pop(context);
                    // itemsBloc.add(FetchItemsEvent());
                  }
                      : null, // Désactive le bouton si _selectedFilters est vide
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: Colors.grey),
                  ),
                  onPressed: () {
                    itemsBloc.add(FilterItemsEvent(_selectedFilters));
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

  void _onFilterChanged(String filter, bool isChecked) {
    setState(() {
      if (isChecked) {
        _selectedFilters.add(filter);
      } else {
        _selectedFilters.remove(filter);
      }
    });

    // Envoyer l'événement au bloc avec les filtres sélectionnés
    // widget.itemsBloc.add(FilterItemsEvent(_selectedFilters));
    // Navigator.pop(context);
  }
}
