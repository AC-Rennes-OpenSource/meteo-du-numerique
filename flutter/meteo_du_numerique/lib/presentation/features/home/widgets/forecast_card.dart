import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:markdown/markdown.dart' as md;

import '../../../../data/models/forecast.dart';

class ForecastCard extends StatelessWidget {
  final Forecast forecast;

  const ForecastCard({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forecastTypeColor = _getForecastTypeColor();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: isDarkMode ? forecastTypeColor : forecastTypeColor.withOpacity(0.7)
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 6.0, top: 6.0),
                    child: Text(
                      forecast.title ?? 'Unnamed Forecast',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: isDarkMode ? forecastTypeColor : forecastTypeColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 0,
                  bottom: 0,
                  child: _getForecastTypeIcon(isDarkMode),
                ),
              ],
            ),
          ),
          Container(
            color: forecastTypeColor,
            height: 35,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getForecastTypeLabel(),
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (forecast.content != null)
                  MarkdownBody(
                    data: forecast.content!,
                    inlineSyntaxes: [
                      UnderlineSyntax(), // Ajoute la syntaxe de soulignement personnalisée
                    ],
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(fontSize: 14.0),
                      del: const TextStyle(decoration: TextDecoration.underline), // Souligne les balises del
                      horizontalRuleDecoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (forecast.service != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.link, size: 16.0),
                            const SizedBox(width: 4.0),
                            Text(
                              'Service: ${forecast.service?.name ?? 'Unknown service'}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        if (forecast.service?.category != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getCategoryColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: _getCategoryColor(),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              forecast.service?.category?.name ?? 'Uncategorized',
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.white 
                                    : Colors.black,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                if (forecast.startDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.schedule, size: 16.0),
                        const SizedBox(width: 4.0),
                        Text(
                          'Starts: ${_formatDate(forecast.startDate!)}',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (forecast.endDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        const Icon(Icons.event_available, size: 16.0),
                        const SizedBox(width: 4.0),
                        Text(
                          'Ends: ${_formatDate(forecast.endDate!)}',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getForecastTypeColor() {
    final type = forecast.forecastTypeId;
    
    switch (type) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  String _getForecastTypeLabel() {
    final type = forecast.forecastTypeId;
    
    switch (type) {
      case 1:
        return 'Maintenance';
      case 2:
        return 'Information';
      case 3:
        return 'Incident';
      default:
        return 'Other';
    }
  }
  
  Widget _getForecastTypeIcon(bool isDarkMode) {
    final type = forecast.forecastTypeId;
    final color = _getForecastTypeColor();
    
    IconData icon;
    
    switch (type) {
      case 1:
        icon = Icons.build;
        break;
      case 2:
        icon = Icons.info;
        break;
      case 3:
        icon = Icons.error_outline;
        break;
      default:
        icon = Icons.help;
    }
    
    return Icon(
      icon,
      color: isDarkMode ? color : color.withOpacity(0.7),
      size: 20,
    );
  }

  String _formatDate(String date) {
    try {
      final dateTime = DateTime.parse(date);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return date;
    }
  }
  
  Color _getCategoryColor() {
    if (forecast.service?.category == null) {
      return Colors.grey;
    }
    
    // Parse the color from the category if available
    if (forecast.service!.category!.color != null) {
      try {
        // Check if color is in hex format (0xffXXXXXX)
        if (forecast.service!.category!.color!.startsWith('0x')) {
          return Color(int.parse(forecast.service!.category!.color!));
        }
      } catch (e) {
        // Fallback to default if parsing fails
      }
    }
    
    // Fallback colors based on category id
    final id = forecast.service!.category!.id ?? 0;
    
    // Use the same color palette as filter_forecasts_bottom_sheet.dart
    final colors = [
      const Color(0xff63BAAB),  // Collaboration
      const Color(0xFFC7A213),  // RH
      const Color(0xffE197A4),  // Finance
      const Color(0xffC25452),  // Pédagogie
      const Color(0xff28619A),  // Examens et concours
      const Color(0xFFD17010),  // Inclusion
      const Color(0xff00B872),  // Scolarité
      const Color(0xFF795548),  // Communication
      const Color(0xFF2196f3),  // Santé et social
    ];
    
    return colors[id % colors.length];
  }
}

/// Classe pour gérer les balises <u> dans le markdown
class UnderlineSyntax extends md.InlineSyntax {
  UnderlineSyntax() : super(r'<u>(.*?)<\/u>');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final String text = match.group(1)!;
    parser.addNode(md.Element.text('del', text));
    return true;
  }
}