import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:meteo_du_numerique/models/service_num_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/theme_bloc/theme_bloc.dart';

class ServiceCardWidget extends StatefulWidget {
  final ActualiteA service;

  const ServiceCardWidget({super.key, required this.service});

  @override
  State<StatefulWidget> createState() => _ServiceCardWidgetState();
}

class _ServiceCardWidgetState extends State<ServiceCardWidget> {
  @override
  Widget build(BuildContext context) {
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
                      widget.service.qualiteDeService!.niveauQos, isDarkMode)
                  : serviceTextColor(
                      widget.service.qualiteDeService!.niveauQos, isDarkMode))),
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
                                widget.service.qualiteDeService!.niveauQos,
                                isDarkMode)),
                      ),
                      const SizedBox(height: kIsWeb ? 8 : 0),
                      // Espace entre l'icône et le texte
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          widget.service.libelle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: kIsWeb ? 26.0 : 22,
                            color: serviceTextColor(
                                widget.service.qualiteDeService!.niveauQos,
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
                            widget.service.libelle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: kIsWeb ? 26.0 : 22,
                              color: serviceTextColor(
                                  widget.service.qualiteDeService!.niveauQos,
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
                                widget.service.qualiteDeService!.niveauQos,
                                isDarkMode) ??
                            const SizedBox(),
                      ),
                    ],
                  ),
          ),
          Container(
            color: serviceColor(
                widget.service.qualiteDeService!.niveauQos, isDarkMode),
            height: 35,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.service.qualiteDeService!.libelle,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
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
                data: widget.service.description,
                styleSheet: MarkdownStyleSheet(
                    // h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                    // h2: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                    // p: TextStyle(fontSize: 16),
                    // blockquote: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    horizontalRuleDecoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                )),
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
