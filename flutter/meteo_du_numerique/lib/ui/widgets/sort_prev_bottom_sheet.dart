import 'package:flutter/material.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_bloc.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_event.dart';

class SortPrevBottomSheet extends StatefulWidget {
  final PrevisionsBloc previsionsBloc;
  final String? selectedSorting;
  final String? selectedOrder;

  const SortPrevBottomSheet(
      {super.key, required this.previsionsBloc, required this.selectedSorting, required this.selectedOrder});

  @override
  State<SortPrevBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortPrevBottomSheet> {
  String? _selectedSortCriteria;
  String? _selectedSortOrder;

  @override
  void initState() {
    super.initState();
    _selectedSortCriteria = widget.selectedSorting!;
    _selectedSortOrder = widget.selectedOrder!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 50.0, top: 10.0, left: 10, right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RadioListTile<String>(
            title: const Text('État décroissant'),
            value: 'qualiteDeServiceId_desc',
            groupValue: '${_selectedSortCriteria!}_${_selectedSortOrder ?? ''}',
            onChanged: (String? value) {
              _onSortChanged('qualiteDeServiceId', 'desc');
            },
          ),
          RadioListTile<String>(
            title: const Text('État croissant'),
            value: 'qualiteDeServiceId_asc',
            groupValue: '${_selectedSortCriteria!}_${_selectedSortOrder ?? ''}',
            onChanged: (String? value) {
              _onSortChanged('qualiteDeServiceId', 'asc');
            },
          ),
          const Divider(),
          RadioListTile<String>(
            title: const Text('Nom du service (A-Z)'),
            value: 'libelle_asc',
            groupValue: '${_selectedSortCriteria!}_${_selectedSortOrder ?? ''}',
            onChanged: (String? value) {
              _onSortChanged('libelle', 'asc');
            },
          ),
          RadioListTile<String>(
            title: const Text('Nom du service (Z-A)'),
            value: 'libelle_desc',
            groupValue: '${_selectedSortCriteria!}_${_selectedSortOrder ?? ''}',
            onChanged: (String? value) {
              _onSortChanged('libelle', 'desc');
            },
          ),
        ],
      ),
    );
  }

  void _onSortChanged(String criteria, String order) {
    setState(() {
      _selectedSortCriteria = criteria;
      _selectedSortOrder = order;
    });

    widget.previsionsBloc.add(SortPrevisionsEvent(criteria, order));
    Navigator.pop(context);
  }
}
