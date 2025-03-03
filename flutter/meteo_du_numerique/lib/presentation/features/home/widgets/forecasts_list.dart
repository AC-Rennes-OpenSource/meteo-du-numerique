import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/blocs/forecasts/forecasts_bloc.dart';
import '../../../../domain/blocs/forecasts/forecasts_state.dart';
import 'forecast_card.dart';

class ForecastsList extends StatelessWidget {
  const ForecastsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForecastsBloc, ForecastsState>(
      builder: (context, state) {
        if (state is ForecastsLoading) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is ForecastsLoaded) {
          final forecasts = state.forecasts;
          
          if (forecasts.isEmpty) {
            return const SliverFillRemaining(
              child: Center(
                child: Text('No forecasts found'),
              ),
            );
          }

          // Group forecasts by date
          final groupedForecasts = <String, List<dynamic>>{};
          for (final forecast in forecasts) {
            final date = forecast.date?.split('T')[0] ?? 'Unknown';
            if (!groupedForecasts.containsKey(date)) {
              groupedForecasts[date] = [];
            }
            groupedForecasts[date]!.add(forecast);
          }

          // Sort dates
          final sortedDates = groupedForecasts.keys.toList()..sort();

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final date = sortedDates[index];
                final dateForecasts = groupedForecasts[date]!;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, 
                        vertical: 8.0
                      ),
                      child: Text(
                        _formatDate(date),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...dateForecasts.map((forecast) => ForecastCard(forecast: forecast)).toList(),
                  ],
                );
              },
              childCount: sortedDates.length,
            ),
          );
        } else if (state is ForecastsError) {
          return SliverFillRemaining(
            child: Center(
              child: Text('Error: ${state.message}'),
            ),
          );
        } else {
          return const SliverFillRemaining(
            child: Center(
              child: Text('Unknown state'),
            ),
          );
        }
      },
    );
  }

  String _formatDate(String date) {
    try {
      final dateTime = DateTime.parse(date);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return date;
    }
  }
}