import 'package:intl/intl.dart';

class Utils {
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

  static bool estMemeJour(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  static String lastUpdateString(DateTime lastUpdate) {
    String form = DateFormat("dd MMMM yyyy", "fr_FR").format(lastUpdate);
    String hour =
        "${DateFormat("H").format(lastUpdate.add(const Duration(hours: 2)))}h${DateFormat("mm").format(lastUpdate)}";
    return "Dernière mise à jour le $form à $hour";
  }
}
