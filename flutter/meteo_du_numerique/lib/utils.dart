import 'package:intl/intl.dart';

class Utils {
  // Exemple de méthode statique pour capitaliser la première lettre d'une chaîne
  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String formatDate1(DateTime date) {
    String stringDay = capitalizeFirstLetter(DateFormat('EEEE', "fr_FR").format(date));
    String suffix = 'er';
    String numDay =
    date.day == 1 ? DateFormat('d', "fr_FR").format(date) + suffix : DateFormat('d', "fr_FR").format(date);
    String month = capitalizeFirstLetter(DateFormat('MMMM', "fr_FR").format(date));
    return '$stringDay $numDay $month';
  }

  static String formatDate2(DateTime date) {
    final df = DateFormat('MMMM y', "fr_FR");
    df.format(date);
    return capitalizeFirstLetter(df.format(date));
  }
}
