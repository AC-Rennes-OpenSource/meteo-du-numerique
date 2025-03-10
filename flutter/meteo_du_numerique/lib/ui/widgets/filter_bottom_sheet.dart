import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/items_bloc/services_num_bloc.dart';
import '../../bloc/items_bloc/services_num_event.dart';
import 'custom_checkbox.dart';

// TODO : composant unique pour les deux tabs??
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
    final itemsBloc = BlocProvider.of<ServicesNumBloc>(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          MyCustomCheckboxTile(
            leadingIcon: const Icon(Icons.flash_on,
                color: Color(
                  0xffdb2c66,
                )),
            title: 'Dysfonctionnement bloquant',
            value: _selectedFilters.contains('dysfonctionnement bloquant'),
            onChanged: (bool? value) {
              _onFilterChanged('dysfonctionnement bloquant', value!);
            },
          ),
          MyCustomCheckboxTile(
            leadingIcon: const Icon(
              CupertinoIcons.umbrella_fill,
              color: Color(0xffdb8b00),
            ),
            title: 'Perturbations',
            value: _selectedFilters.contains('perturbations'),
            onChanged: (value) {
              _onFilterChanged('perturbations', value);
            },
          ),
          MyCustomCheckboxTile(
            leadingIcon: const Icon(
              Icons.sunny,
              color: Color(0xff3db482),
            ),
            title: 'Fonctionnement habituel',
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
                      iconColor: Theme.of(context).colorScheme.onSurface,
                      side: const BorderSide(width: 1.0, color: Colors.grey),
                      foregroundColor:
                          _selectedFilters.isEmpty ? Colors.grey : Theme.of(context).colorScheme.onSurface),
                  icon: const Icon(Icons.close),
                  label: const Text("Réinitialiser"),
                  onPressed: _selectedFilters.isNotEmpty
                      ? () {
                          setState(() {
                            _selectedFilters.clear();
                          });
                        }
                      : null, // Désactive le bouton si _selectedFilters est vide
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    side: const BorderSide(width: 1.0, color: Colors.grey),
                  ),
                  onPressed: () {
                    itemsBloc.add(FilterServicesNumEvent(_selectedFilters));
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
  }
}
