import 'package:diacritic/diacritic.dart';
import 'package:intl/intl.dart';

class AppUtils {
  /// Removes accents and diacritics from text and converts to lowercase
  static String normalizeText(String text) {
    return removeDiacritics(text.toLowerCase());
  }

  /// Formats a date to a long readable format
  static String formatLongDate(DateTime date) {
    return DateFormat("d MMMM yyyy", "en_US").format(date);
  }
  
  /// Returns a human-readable "Last updated at..." string
  static String lastUpdateString(DateTime? lastUpdate) {
    if (lastUpdate == null) {
      return 'Last update: unknown';
    }
    
    final now = DateTime.now();
    final difference = now.difference(lastUpdate);
    
    if (difference.inMinutes < 1) {
      return 'Last update: just now';
    } else if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return 'Last update: $minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inDays < 1) {
      final hours = difference.inHours;
      return 'Last update: $hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else {
      final days = difference.inDays;
      if (days < 30) {
        return 'Last update: $days ${days == 1 ? 'day' : 'days'} ago';
      } else {
        final formatter = DateFormat('dd/MM/yyyy HH:mm');
        return 'Last update: ${formatter.format(lastUpdate)}';
      }
    }
  }
}
