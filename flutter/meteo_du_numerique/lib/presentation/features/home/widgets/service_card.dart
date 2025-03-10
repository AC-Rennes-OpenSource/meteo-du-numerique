import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import '../../../../data/models/digital_service.dart';

class ServiceCard extends StatelessWidget {
  final DigitalService service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final serviceColor = _getServiceColor(isDarkMode);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: isDarkMode 
              ? serviceColor 
              : _getServiceTextColor(isDarkMode)
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
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
                      service.name ?? 'Unnamed Service',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: _getServiceTextColor(isDarkMode),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 0,
                  bottom: 0,
                  child: _getServiceIcon(isDarkMode),
                ),
              ],
            ),
          ),
          Container(
            color: serviceColor,
            height: 35,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getServiceQualityLabel(),
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: service.description != null
              ? MarkdownBody(
                  data: service.description!,
                  selectable: true,
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
                )
              : const Text('No description available'),
          ),
          if (service.category != null)
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Container(
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
                  service.category?.name ?? 'Uncategorized',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.white 
                        : Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getServiceColor(bool isDarkMode) {
    final quality = service.qualityOfService?.id ?? 0;
    
    switch (quality) {
      case 1:
        return const Color(0xff3db482); // Green operational
      case 2:
        return const Color(0xffdb8b00); // Orange degraded
      case 3:
        return const Color(0xffdb2c66); // Red down
      default:
        return Colors.grey;
    }
  }
  
  Color _getServiceTextColor(bool isDarkMode) {
    final quality = service.qualityOfService?.id ?? 0;
    
    switch (quality) {
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
  
  String _getServiceQualityLabel() {
    final quality = service.qualityOfService?.id ?? 0;
    
    switch (quality) {
      case 1:
        return service.qualityOfService?.name ?? 'Operational';
      case 2:
        return service.qualityOfService?.name ?? 'Degraded';
      case 3:
        return service.qualityOfService?.name ?? 'Down';
      default:
        return 'Unknown';
    }
  }
  
  Widget _getServiceIcon(bool isDarkMode) {
    final quality = service.qualityOfService?.id ?? 0;
    
    IconData icon;
    Color color = _getServiceTextColor(isDarkMode);
    
    switch (quality) {
      case 1:
        icon = Icons.sunny;
        break;
      case 2:
        icon = CupertinoIcons.umbrella_fill;
        break;
      case 3:
        icon = Icons.flash_on;
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
  
  Color _getCategoryColor() {
    // Parse the color from the category if available
    if (service.category?.color != null) {
      try {
        // Check if color is in hex format (0xffXXXXXX)
        if (service.category!.color!.startsWith('0x')) {
          return Color(int.parse(service.category!.color!));
        }
      } catch (e) {
        // Fallback to default if parsing fails
      }
    }
    
    // Fallback colors based on category id or name
    final id = service.category?.id ?? 0;
    
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
  
  /// Workaround: permet de remplacer les balises <u> provenant des textes soulignés de Strapi
  /// par des balises <del> qui sont formatables via la lib flutter_markdown.
  /// On peut ainsi appliquer le style de soulignement au texte voulu.
  /// NB : la norme markdown ne prévoit pas de syntaxe de soulignement, d'où cette absence dans flutter_markdown
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