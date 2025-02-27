import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:meteo_du_numerique/models/service_num_model.dart';
import 'package:markdown/markdown.dart' as md;


import '../../bloc/theme_bloc/theme_bloc.dart';

class ServiceCardWidget extends StatelessWidget {
  final ActualiteA service;

  const ServiceCardWidget({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    String markdownText = service.description;

    // Transformation du markdown en HTML
    String htmlText = md.markdownToHtml(markdownText);

    // Accès à l'état du Bloc pour savoir si le mode sombre est activé
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    bool isDarkMode = themeBloc.state.isDarkMode;

    return Container(
      decoration: BoxDecoration(
          borderRadius:
              kIsWeb ? BorderRadius.circular(2) : BorderRadius.circular(10.0),
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
              color: isDarkMode
                  ? serviceColor(
                      service.qualiteDeService!.niveauQos, isDarkMode)
                  : serviceTextColor(
                      service.qualiteDeService!.niveauQos, isDarkMode))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 3, right: 3),
            child: kIsWeb
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Center(
                            child: getIcon(
                                service.qualiteDeService!.niveauQos,
                                isDarkMode)),
                      ),
                      const SizedBox(height: kIsWeb ? 8 : 0),
                      // Espace entre l'icône et le texte
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          service.libelle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: kIsWeb ? 26.0 : 22,
                            color: serviceTextColor(
                                service.qualiteDeService!.niveauQos,
                                isDarkMode),
                          ),
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6.0, top: 6.0),
                          child: Text(
                            service.libelle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: kIsWeb ? 26.0 : 22,
                              color: serviceTextColor(
                                  service.qualiteDeService!.niveauQos,
                                  isDarkMode),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 0,
                        bottom: 0,
                        child: getIcon(
                                service.qualiteDeService!.niveauQos,
                                isDarkMode) ??
                            const SizedBox(),
                      ),
                    ],
                  ),
          ),
          Container(
            color: serviceColor(
                service.qualiteDeService!.niveauQos, isDarkMode),
            height: 35,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  service.qualiteDeService!.libelle,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0, left: 4, right: 4),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: HtmlWidget(
                textStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black, // Couleur selon le mode
                ),
                htmlText, // HTML converti depuis Markdown
              ),
            ),
          ),
        ],
      ),
    );
  }

  Icon? getIcon(int qualiteDeServiceId, bool isDarkMode) {
    switch (qualiteDeServiceId) {
      case 1:
        return Icon(
          Icons.sunny,
          color: isDarkMode ? const Color(0xff3db482) : const Color(0xff247566),
          size: kIsWeb ? 30 : 20,
        );
      case 2:
        return Icon(
          CupertinoIcons.umbrella_fill,
          color: isDarkMode ? const Color(0xffdb8b00) : const Color(0xff945400),
          size: kIsWeb ? 30 : 20,
        );
      case 3:
        return Icon(
          Icons.flash_on,
          color: isDarkMode ? const Color(0xffdb2c66) : const Color(0xff94114e),
          size: kIsWeb ? 30 : 20,
        );
    }
    return null;
  }

  static serviceColor(int qualiteDeServiceId, isDarkTheme) {
    switch (qualiteDeServiceId) {
      case 1:
        return const Color(0xff3db482);
      case 2:
        return const Color(0xffdb8b00);
      case 3:
        return const Color(0xffdb2c66);
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