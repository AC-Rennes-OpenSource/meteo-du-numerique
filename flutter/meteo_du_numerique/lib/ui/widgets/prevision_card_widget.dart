import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/service_num_model.dart';
import '../../utils.dart';

class PrevisionCardWidget extends StatelessWidget {
  final PrevisionA prevision;

  const PrevisionCardWidget({super.key, required this.prevision});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: kIsWeb ? BorderRadius.circular(2) : BorderRadius.circular(10.0),
          color: Theme.of(context).colorScheme.background,
          border: Border.all(color: categoryColor(prevision.couleur))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 3, right: 3),
            child: kIsWeb
                ? Column(
                    children: [
                      const SizedBox(height: 8),
                      // Espace entre l'icône et le texte
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          prevision.libelle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26.0,
                            color: categoryColor(prevision.couleur),
                          ),
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      prevision.libelle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: categoryColor(prevision.couleur),
                      ),
                    ),
                  ),
          ),
          Container(
            color: categoryColor(prevision.couleur),
            height: 35,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  prevision.categorieLibelle,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(Utils.formatDate1(prevision.dateDebut), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0, left: 4, right: 4),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: MarkdownBody(
                  selectable: true,
                  onTapLink: (text, url, title) {
                    launchUrl(Uri.parse(url!));
                  },
                  data: prevision.description),
            ),
          ),
        ],
      ),
    );
  }

  static const List<Widget> icons = <Widget>[
    Icon(
      Icons.sunny,
      color: Color(0xff247566),
      size: 17,
    ),
    Icon(CupertinoIcons.umbrella_fill, color: Color(0xff945400), size: 17),
    Icon(Icons.flash_on, color: Color(0xff94114e), size: 17),
  ];

  Icon? getIcon(int qualiteDeServiceId, bool isDarkMode) {
    switch (qualiteDeServiceId) {
      case 1:
        return Icon(
          Icons.sunny,
          color: isDarkMode ? const Color(0xff3db482) : const Color(0xff247566),
          size: kIsWeb ? 30 : 17,
        );
      case 2:
        return Icon(
          CupertinoIcons.umbrella_fill,
          color: isDarkMode ? const Color(0xffdb8b00) : const Color(0xff945400),
          size: kIsWeb ? 30 : 17,
        );
      case 3:
        return Icon(
          Icons.flash_on,
          color: isDarkMode ? const Color(0xffdb2c66) : const Color(0xff94114e),
          size: kIsWeb ? 30 : 17,
        );
    }
    return null;
  }

  static categoryColor(String category) {
    Color orange = const Color(0xFFD17010);
    Color jaune = const Color(0xFFC7A213);
    Color vert = const Color(0xff63BAAB);
    Color bleu = const Color(0xff28619A);
    Color rose = const Color(0xffC25452);
    switch (category) {
      case "rose":
        return rose;
      case "bleu":
        return bleu;
      case "jaune":
        return jaune;
      case "orange":
        return orange;
      case "vert":
        return vert;
    }
  }

  static serviceTextColor(int qualiteDeServiceId, isDarkTheme) {
    switch (qualiteDeServiceId) {
      case 1:
        return isDarkTheme ? const Color(0xff3db482) : const Color(0xff247566);
      case 2:
        return isDarkTheme ? const Color(0xffdb8b00) : const Color(0xff945400);
      case 3:
        return isDarkTheme ? const Color(0xffdb2c66) : const Color(0xff94114e);
    }
  }
}
