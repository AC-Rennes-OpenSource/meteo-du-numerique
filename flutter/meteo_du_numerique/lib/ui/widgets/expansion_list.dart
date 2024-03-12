import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/bloc/previsions_bloc/previsions_event.dart';
import 'package:meteo_du_numerique/ui/widgets/prevision_card_widget.dart';

import '../../bloc/previsions_bloc/previsions_bloc.dart';
import '../../bloc/previsions_bloc/previsions_state.dart';
import '../../models/prevision_model.dart';
import '../../models/service_num_model.dart';
import '../../utils.dart';

class ExpansionList extends StatelessWidget {
  final bool dayPrevison;

  const ExpansionList({super.key, required this.dayPrevison});

  @override
  Widget build(BuildContext context) {
    context.read<PrevisionsBloc>().add(FetchPrevisionsEvent());

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
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 6, left: 6),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondaryContainer
                          .withOpacity(0.3), // Couleur de fond du Container
                      borderRadius: BorderRadius.circular(5), // Bords arrondis
                      border: state.dayPrevisions.isNotEmpty
                          ? Border.all(
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                              width: 1,
                            )
                          : null),
                  child: ExpansionPanelList(
                    materialGapSize: 0,
                    dividerColor: Colors.transparent,
                    expandIconColor: Theme.of(context).colorScheme.primary,
                    expandedHeaderPadding: const EdgeInsets.only(bottom: 0),
                    elevation: 0,
                    expansionCallback: (int index, bool isExpanded) {
                      context.read<PrevisionsBloc>().add(ToggleDayPrevisionGroupEvent());
                    },
                    children: state.dayPrevisions.map<ExpansionPanel>((PrevisionA prev) {
                      return ExpansionPanel(
                        canTapOnHeader: true,
                        backgroundColor: Colors.transparent,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return const ListTile(title: Text("Événements du jour"));
                        },
                        body: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Column(
                            children: state.dayPrevisions.map<Widget>((prevision) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                child: PrevisionCardWidget(prevision: prevision),
                              );
                            }).toList(),
                          ),
                        ),
                        isExpanded: state.isDayPanelOpen,
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          } else {
            return state.previsionsGroupedByMonth.isEmpty
                ? const SliverFillRemaining(
                    child: Center(child: Text('Pas de résultat.')),
                  )
                : SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 100.0),
                      child: ExpansionPanelList(
                        materialGapSize: 0,
                        dividerColor: Colors.transparent,
                        // animationDuration: const Duration(milliseconds: 250),
                        expandIconColor: Theme.of(context).colorScheme.primary,
                        expandedHeaderPadding: const EdgeInsets.only(bottom: 0),
                        elevation: 0,
                        expansionCallback: (int index, bool isExpanded) {
                          final year = state.previsionsGroupedByMonth.keys.elementAt(index).substring(0, 4);
                          final month = state.previsionsGroupedByMonth.keys.elementAt(index).substring(4, 6);

                          context.read<PrevisionsBloc>().add(TogglePrevisionGroupEvent(month: month, year: year));
                        },
                        children: state.previsionsGroupedByMonth.entries.map<ExpansionPanel>((entry) {
                          final year = entry.key.substring(0, 4);
                          final month = entry.key.substring(4, 6);

                          // On ajoute un jour par défaut pour créer un format de date parsable
                          String formattedDateString = "$year-$month-01";
                          DateTime dateTime = DateTime.parse(formattedDateString);

                          return ExpansionPanel(
                            // canTapOnHeader: true,
                            backgroundColor: Colors.transparent,
                            headerBuilder: (BuildContext context, bool isExpanded) {
                              return ListTile(title: Text(Utils.formatDate2(dateTime)));
                            },
                            body: Column(
                              children: entry.value.map<Widget>((prevision) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  child: PrevisionCardWidget(prevision: prevision),
                                );
                              }).toList(),
                            ),
                            isExpanded: state.expandedGroups[entry.key] ?? false,
                          );
                        }).toList(),
                      ),
                    ),
                  );
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
}

// Classe pour représenter un groupe de prévisions
class PrevisionGroup {
  final String dateDebut;
  final List<Prevision> previsions;
  bool isExpanded;

  PrevisionGroup({
    required this.dateDebut,
    required this.previsions,
    this.isExpanded = false,
  });

  PrevisionGroup copyWith({bool? isExpanded}) {
    return PrevisionGroup(
      dateDebut: dateDebut,
      previsions: previsions,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
