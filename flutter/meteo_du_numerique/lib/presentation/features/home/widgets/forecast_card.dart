import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import '../../../../data/models/forecast.dart';

class ForecastCard extends StatelessWidget {
  final Forecast forecast;

  const ForecastCard({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    final forecastTypeColor = _getForecastTypeColor();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: _getCategorySecondaryColor(isDarkMode)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 3, right: 3),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 6.0, top: 6.0),
                    child: Text(
                      forecast.service?.name ?? 'Service inconnu',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: _getCategorySecondaryColor(isDarkMode),
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 1. Dates formattées
                if (forecast.startDate != null && forecast.endDate != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16.0),
                        const SizedBox(width: 6.0),
                        Expanded(
                          child: Text(
                            _formatDateRange(forecast.startDate!, forecast.endDate!),
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // 2. Libellé de la prévision en gras et plus gros (première ligne du contenu)
                if (forecast.title != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                    child: Text(
                      forecast.title ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),

                // 3. Description de la prévision (reste du contenu)
                if (forecast.content != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: MarkdownBody(
                      data: forecast.content ?? '',
                      // data: forecast.content!.substring(forecast.content!.indexOf("\n\n") + 2),
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
                  ),

                // 4. Catégorie
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
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      ),
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
        return const Color(0xff3db482);
      case 2:
        return const Color(0xffdb8b00);
      case 3:
        return const Color(0xffdb2c66);
      default:
        return Colors.grey;
    }
  }

  Color _getCategorySecondaryColor(bool isDarkMode) {
    final type = forecast.forecastTypeId;

    switch (type) {
      case 1:
        return isDarkMode ? const Color(0xff3db482) : const Color(0xff247566);
      case 2:
        return isDarkMode ? const Color(0xffdb8b00) : const Color(0xff945400);
      case 3:
        return isDarkMode ? const Color(0xffdb2c66) : const Color(0xff94114e);
      default:
        return Colors.grey;
    }
  }

  String _getForecastTypeLabel() {
    // Use the forecast type name if available
    if (forecast.forecastTypeName != null && forecast.forecastTypeName!.isNotEmpty) {
      // Capitalize the first letter
      final typeName = forecast.forecastTypeName!;
      if (typeName.isNotEmpty) {
        return typeName[0].toUpperCase() + typeName.substring(1);
      }
      return typeName;
    }

    // Fallback to ID-based mapping if name not available
    final type = forecast.forecastTypeId;
    switch (type) {
      case 1:
        return 'Maintenance sans perturbations';
      case 2:
        return 'Maintenance avec perturbations';
      case 3:
        return 'Maintenance bloquante';
      default:
        return '';
    }
  }

  Widget _getForecastTypeIcon(bool isDarkMode) {
    final type = forecast.forecastTypeId;
    final color = _getCategorySecondaryColor(isDarkMode);

    IconData icon;

    switch (type) {
      case 1:
        icon = Icons.info;
        break;
      case 2:
        icon = Icons.build;
        break;
      case 3:
        icon = Icons.warning_amber;
        break;
      default:
        icon = Icons.help;
    }

    return Icon(
      icon,
      color: color,
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

  String _formatDateRange(String startDate, String endDate) {
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);

      // Liste des noms des mois en français
      final months = ['', 'janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'];

      // Si même année
      if (start.year == end.year) {
        // Si même mois
        if (start.month == end.month) {
          return 'Du ${start.day} au ${end.day} ${months[end.month]} ${end.year}';
        } else {
          return 'Du ${start.day} ${months[start.month]} au ${end.day} ${months[end.month]} ${end.year}';
        }
      } else {
        return 'Du ${start.day} ${months[start.month]} ${start.year} au ${end.day} ${months[end.month]} ${end.year}';
      }
    } catch (e) {
      return 'Du $startDate au $endDate';
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
      const Color(0xff63BAAB), // Collaboration
      const Color(0xFFC7A213), // RH
      const Color(0xffE197A4), // Finance
      const Color(0xffC25452), // Pédagogie
      const Color(0xff28619A), // Examens et concours
      const Color(0xFFD17010), // Inclusion
      const Color(0xff00B872), // Scolarité
      const Color(0xFF795548), // Communication
      const Color(0xFF2196f3), // Santé et social
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
