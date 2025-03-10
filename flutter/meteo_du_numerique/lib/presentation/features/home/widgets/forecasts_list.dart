import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/blocs/forecasts/forecasts_bloc.dart';
import '../../../../domain/blocs/forecasts/forecasts_state.dart';
import 'forecast_card.dart';

class ForecastsList extends StatelessWidget {
  const ForecastsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForecastsBloc, ForecastsState>(
      builder: (context, state) {
        if (state is ForecastsLoading) {
          return SliverFillRemaining(
            child: Center(
              child: Platform.isIOS ? const Center(child: CupertinoActivityIndicator(radius: 15)) : const Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (state is ForecastsLoaded) {
          final forecasts = state.forecasts;

          if (forecasts.isEmpty) {
            return const SliverFillRemaining(
              child: Center(
                child: Text('Pas de résultat'),
              ),
            );
          }

          // Group forecasts by month
          final groupedForecasts = <String, List<dynamic>>{};
          for (final forecast in forecasts) {
            if (forecast.startDate == null) continue;
            
            try {
              final dateTime = DateTime.parse(forecast.startDate!);
              // Format as "Month Year" (ex: "Mars 2025")
              final monthYear = _formatMonthYear(dateTime);
              
              if (!groupedForecasts.containsKey(monthYear)) {
                groupedForecasts[monthYear] = [];
              }
              groupedForecasts[monthYear]!.add(forecast);
            } catch (e) {
              // Fallback for unparseable dates
              const unknown = 'Date inconnue';
              if (!groupedForecasts.containsKey(unknown)) {
                groupedForecasts[unknown] = [];
              }
              groupedForecasts[unknown]!.add(forecast);
            }
          }

          // Sort months chronologically
          final sortedMonths = groupedForecasts.keys.toList()
            ..sort((a, b) {
              if (a == 'Date inconnue') return 1;
              if (b == 'Date inconnue') return -1;
              
              try {
                // Parse month names back to dates for comparison
                final monthsMap = _getMonthsMap();
                final partsA = a.split(' ');
                final partsB = b.split(' ');
                
                final yearA = int.parse(partsA[1]);
                final yearB = int.parse(partsB[1]);
                if (yearA != yearB) return yearA.compareTo(yearB);
                
                final monthA = monthsMap[partsA[0]] ?? 1;
                final monthB = monthsMap[partsB[0]] ?? 1;
                return monthA.compareTo(monthB);
              } catch (e) {
                return a.compareTo(b); // Fallback to string comparison
              }
            });

          return SliverList(

            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == groupedForecasts.length) {
                  // Add bottom padding after the last item
                  return const SizedBox(height: 100);
                }
                final monthYear = sortedMonths[index];
                final monthForecasts = groupedForecasts[monthYear]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 12.0),
                      child: Text(
                        monthYear,
                        style: const TextStyle(
                          fontSize: 18,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...monthForecasts.map((forecast) => ForecastCard(forecast: forecast)),
                  ],
                );
              },
              childCount: sortedMonths.length + 1, // +1 for bottom padding
            ),
          );
        } else if (state is ForecastsError) {
          return SliverFillRemaining(
            child: Center(
              child: Center(child: Text('Un problème de connexion est survenu.')),
            ),
          );
        } else {
          return const SliverFillRemaining(
            child: Center(
              child: Center(child: Text('Chargement...')),
            ),
          );
        }
      },
    );
  }

  String _formatMonthYear(DateTime dateTime) {
    final months = [
      '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    
    return '${months[dateTime.month]} ${dateTime.year}';
  }
  
  Map<String, int> _getMonthsMap() {
    return {
      'Janvier': 1, 'Février': 2, 'Mars': 3, 'Avril': 4, 'Mai': 5, 'Juin': 6,
      'Juillet': 7, 'Août': 8, 'Septembre': 9, 'Octobre': 10, 'Novembre': 11, 'Décembre': 12
    };
  }
}
