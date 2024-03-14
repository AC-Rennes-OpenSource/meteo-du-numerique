import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data_model.dart';

class ServiceCardWidget extends StatelessWidget {
  final Service service;

  const ServiceCardWidget({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Colors.white,
          border: Border.all(color: serviceColor(service.qualiteDeServiceId))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 3, right: 3),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(child: getIcon(service.qualiteDeServiceId)),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    service.libelle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0,
                      color: serviceTextColor(service.qualiteDeServiceId),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: serviceColor(service.qualiteDeServiceId),
            height: 35,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  service.qualiteDeService,
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
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
                  data: service.description),
            ),
          ),
        ],
      ),
    );
  }

  serviceColor(int qualiteDeServiceId) {
    switch (qualiteDeServiceId) {
      case 1:
        return const Color(0xff3db482);
      case 2:
        return const Color(0xffdb8b00);
      case 3:
        return const Color(0xffdb2c66);
    }
  }

  serviceTextColor(int qualiteDeServiceId) {
    switch (qualiteDeServiceId) {
      case 1:
        const Color(0xff247566);
      case 2:
        const Color(0xff945400);
      case 3:
        const Color(0xff94114e);
    }
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

  Icon? getIcon(int qualiteDeServiceId) {
    switch (qualiteDeServiceId) {
      case 1:
        return const Icon(
          Icons.sunny,
          color: Color(0xff247566),
          size: 30,
        );
      case 2:
        return const Icon(
          CupertinoIcons.umbrella_fill,
          color: Color(0xff945400),
          size: 30,
        );
      case 3:
        return const Icon(
          Icons.flash_on,
          color: Color(0xff94114e),
          size: 30,
        );
    }
    return null;
  }
}
