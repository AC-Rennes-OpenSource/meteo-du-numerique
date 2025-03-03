import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_event.dart';
import 'package:meteo_du_numerique/ui/widgets/prevision_card_widget.dart';

import '../../bloc/previsions_bloc/previsions_bloc_2.dart';
import '../../bloc/previsions_bloc/previsions_state.dart';
import '../../models/service_num_model.dart';

class ExpansionList extends StatelessWidget {
  final bool dayPrevison;

  const ExpansionList({super.key, required this.dayPrevison});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrevisionsBloc, PrevisionsState>(
      builder: (context, state) {
        if (state is PrevisionsLoading) {
          return SliverFillRemaining(
            child: Platform.isIOS
                ? const Center(child: CupertinoActivityIndicator(radius: 15))
                : const Center(child: CircularProgressIndicator()),
          );
        } else if (state is PrevisionsLoaded) {
          if (dayPrevison) {
            return _buildDayPrevisionsPanel(context, state);
          } else {
            return _buildMonthPrevisionsPanel(context, state);
          }
        } else if (state is PrevisionsError) {
          return const SliverFillRemaining(
            child: Center(child: Text('Un problème de connexion est survenu.')),
          );
        } else {
          return const SliverFillRemaining(
            child: Center(child: Text('Chargement...')),
          );
        }
      },
    );
  }

  Widget _buildDayPrevisionsPanel(BuildContext context, PrevisionsLoaded state) {
    if (state.dayPrevisions.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: Text('Pas d\'événements aujourd\'hui.')),
      );
    }

    // Get the first key and its corresponding list
    final firstKey = state.dayPrevisions.keys.first;
    final previsions = state.dayPrevisions[firstKey] ?? [];

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, right: 6, left: 6),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.teal.withAlpha(25),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.teal.withAlpha(75),
              width: 1,
            ),
          ),
          child: ExpansionPanelList(
            materialGapSize: 0,
            dividerColor: Colors.transparent,
            expandIconColor: Theme.of(context).colorScheme.primary,
            expandedHeaderPadding: const EdgeInsets.only(bottom: 0),
            elevation: 0,
            expansionCallback: (int index, bool isExpanded) {
              context.read<PrevisionsBloc>().add(ToggleDayPrevisionGroupEvent());
            },
            children: [
              ExpansionPanel(
                canTapOnHeader: true,
                backgroundColor: Colors.transparent,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return const ListTile(title: Text("Événements du jour"));
                },
                body: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Column(
                    children: previsions.map<Widget>((prevision) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: PrevisionCardWidget(prevision: prevision),
                      );
                    }).toList(),
                  ),
                ),
                isExpanded: state.isDayPanelOpen,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthPrevisionsPanel(BuildContext context, PrevisionsLoaded state) {
    if (state.previsionsGroupedByMonth.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: Text('Pas de prévisions.')),
      );
    }

    List<ExpansionPanel> panels = [];
    
    state.previsionsGroupedByMonth.forEach((key, previsions) {
      panels.add(
        ExpansionPanel(
          backgroundColor: Colors.transparent,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(title: Text(key)); // Key is already formatted month/year
          },
          body: Column(
            children: previsions.map<Widget>((PrevisionA prevision) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: PrevisionCardWidget(prevision: prevision),
              );
            }).toList(),
          ),
          isExpanded: state.expandedGroups[key] ?? false,
        ),
      );
    });

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: ExpansionPanelList(
          materialGapSize: 0,
          dividerColor: Colors.transparent,
          expandIconColor: Theme.of(context).colorScheme.primary,
          expandedHeaderPadding: const EdgeInsets.only(bottom: 0),
          elevation: 0,
          expansionCallback: (int index, bool isExpanded) {
            final key = state.previsionsGroupedByMonth.keys.elementAt(index);
            final month = key.split(' ')[0]; // Extract month from formatted string
            final year = key.split(' ')[1]; // Extract year from formatted string
            context.read<PrevisionsBloc>().add(TogglePrevisionGroupEvent(month: month, year: year));
          },
          children: panels,
        ),
      ),
    );
  }
}
