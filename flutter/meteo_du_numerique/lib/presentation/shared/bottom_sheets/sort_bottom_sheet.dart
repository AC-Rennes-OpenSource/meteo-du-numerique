import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/blocs/digital_services/digital_services_bloc.dart';
import '../../../domain/blocs/digital_services/digital_services_event.dart';

class SortBottomSheet extends StatefulWidget {
  final DigitalServicesBloc servicesBloc;
  final String? selectedSorting;
  final String? selectedOrder;

  const SortBottomSheet({
    Key? key,
    required this.servicesBloc,
    required this.selectedSorting,
    required this.selectedOrder,
  }) : super(key: key);

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  late String _selectedSorting;
  late String _selectedOrder;

  @override
  void initState() {
    super.initState();
    _selectedSorting = widget.selectedSorting ?? 'name';
    _selectedOrder = widget.selectedOrder ?? 'asc';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 50.0, top: 20.0, left: 10, right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            title: const Text('État du service décroissant'),
            value: 'serviceQualityId_desc',
            groupValue: '${_selectedSorting}_${_selectedOrder}',
            onChanged: (String? value) {
              _onSortChanged('serviceQualityId', 'desc');
            },
          ),
          RadioListTile<String>(
            title: const Text('État du service croissant'),
            value: 'serviceQualityId_asc',
            groupValue: '${_selectedSorting}_${_selectedOrder}',
            onChanged: (String? value) {
              _onSortChanged('serviceQualityId', 'asc');
            },
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10.0, bottom: 10.0),
            child: Divider(),
          ),
          RadioListTile<String>(
            title: const Text('Nom du service (A-Z)'),
            value: 'name_asc',
            groupValue: '${_selectedSorting}_${_selectedOrder}',
            onChanged: (String? value) {
              _onSortChanged('name', 'asc');
            },
          ),
          RadioListTile<String>(
            title: const Text('Nom du service (Z-A)'),
            value: 'name_desc',
            groupValue: '${_selectedSorting}_${_selectedOrder}',
            onChanged: (String? value) {
              _onSortChanged('name', 'desc');
            },
          ),
        ],
      ),
    );
  }

  void _onSortChanged(String criteria, String order) {
    setState(() {
      _selectedSorting = criteria;
      _selectedOrder = order;
    });

    widget.servicesBloc.add(SortDigitalServicesEvent(criteria, order));
    Navigator.pop(context);
  }
}