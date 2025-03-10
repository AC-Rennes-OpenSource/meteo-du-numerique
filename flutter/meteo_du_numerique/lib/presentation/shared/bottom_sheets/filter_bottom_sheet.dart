import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/blocs/digital_services/digital_services_bloc.dart';
import '../../../domain/blocs/digital_services/digital_services_event.dart';
import '../../../domain/blocs/digital_services/digital_services_state.dart';
import '../../../presentation/common/widgets/custom_checkbox/custom_checkbox.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String> selectedFilters;
  final List<String> selectedCategories;
  final int tab;

  const FilterBottomSheet({
    super.key,
    required this.selectedFilters,
    this.selectedCategories = const [],
    required this.tab,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  List<String> selectedFilters = [];
  List<String> selectedCategories = [];
  
  @override
  void initState() {
    super.initState();
    selectedFilters = List.from(widget.selectedFilters);
    selectedCategories = List.from(widget.selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    final servicesBloc = BlocProvider.of<DigitalServicesBloc>(context);

    return BlocBuilder<DigitalServicesBloc, DigitalServicesState>(
      builder: (context, state) {
        if (state is DigitalServicesLoaded) {
          final filters = [
            {'id': '3', 'name': 'Dysfonctionnement bloquant', 'icon': Icons.flash_on},
            {'id': '2', 'name': 'Perturbations', 'icon': CupertinoIcons.umbrella_fill},
            {'id': '1', 'name': 'Fonctionnement habituel', 'icon': Icons.sunny},
          ];
          
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
          
          Color getChipColor(int index) {
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
          
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                ListView.builder(
                  padding: EdgeInsets.zero, // Supprime le padding par défaut
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                  padding: EdgeInsets.only(left: 15, right: 25, bottom: 20.0, top: 20.0),
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
                        selectedColor: getChipColor(index),
                        checkmarkColor: Colors.white,
                        backgroundColor: selectedCategories.contains(category['id'])
                          ? getChipColor(index)
                          : getChipColor(index).withOpacity(0.1),
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
                          side: BorderSide(color: getChipColor(index), width: 2),
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
                          foregroundColor: selectedFilters.isEmpty && selectedCategories.isEmpty
                              ? Colors.grey 
                              : Theme.of(context).colorScheme.onSurface
                        ),
                        icon: const Icon(Icons.close),
                        label: const Text("Réinitialiser"),
                        onPressed: selectedFilters.isNotEmpty || selectedCategories.isNotEmpty
                          ? () {
                              setState(() {
                                selectedFilters.clear();
                                selectedCategories.clear();
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
                          servicesBloc.add(FilterDigitalServicesEvent(
                            selectedFilters,
                            categoryFilters: selectedCategories,
                          ));
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