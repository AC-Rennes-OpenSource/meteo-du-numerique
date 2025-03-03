import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/blocs/digital_services/digital_services_bloc.dart';
import '../../../domain/blocs/digital_services/digital_services_event.dart';
import '../../../domain/blocs/digital_services/digital_services_state.dart';
import '../../../presentation/common/widgets/custom_checkbox/custom_checkbox.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String> selectedFilters;
  final int tab;

  const FilterBottomSheet({
    Key? key,
    required this.selectedFilters,
    required this.tab,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  List<String> selectedFilters = [];

  @override
  void initState() {
    super.initState();
    selectedFilters = List.from(widget.selectedFilters);
  }

  @override
  Widget build(BuildContext context) {
    final servicesBloc = BlocProvider.of<DigitalServicesBloc>(context);

    return BlocBuilder<DigitalServicesBloc, DigitalServicesState>(
      builder: (context, state) {
        if (state is DigitalServicesLoaded) {
          final filters = [
            {'id': '3', 'name': 'Dysfonctionnement bloquant', 'icon': Icons.flash_on},
            {'id': '2', 'name': 'Perturbations', 'icon': Icons.umbrella},
            {'id': '1', 'name': 'Fonctionnement habituel', 'icon': Icons.sunny},
          ];
          
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    final isSelected = selectedFilters.contains(filter['id']);
                    
                    // Map icons to match the original UI
                    IconData iconData = filter['icon'] as IconData;
                    Color iconColor;
                    
                    if (filter['name'] == 'Fonctionnement habituel') {
                      iconColor = const Color(0xff3db482);
                    } else if (filter['name'] == 'Perturbations') {
                      iconColor = const Color(0xffdb8b00);
                    } else { // Dysfonctionnement bloquant
                      iconColor = const Color(0xffdb2c66);
                    }
                    
                    return CustomCheckboxTile(
                      title: filter['name'] as String,
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value) {
                            selectedFilters.add(filter['id'] as String);
                          } else {
                            selectedFilters.remove(filter['id']);
                          }
                        });
                      },
                      leadingIcon: Icon(iconData, color: iconColor),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15, right: 25, bottom: 15.0),
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
                          foregroundColor: selectedFilters.isEmpty 
                              ? Colors.grey 
                              : Theme.of(context).colorScheme.onSurface
                        ),
                        icon: const Icon(Icons.close),
                        label: const Text("Réinitialiser"),
                        onPressed: selectedFilters.isNotEmpty
                          ? () {
                              setState(() {
                                selectedFilters.clear();
                              });
                            }
                          : null,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.onSurface,
                          side: const BorderSide(width: 1.0, color: Colors.grey),
                        ),
                        onPressed: () {
                          servicesBloc.add(FilterDigitalServicesEvent(selectedFilters));
                          Navigator.pop(context);
                        },
                        child: const Text("Appliquer"),
                      ),
                    ],
                  ),
                ),
              ],
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