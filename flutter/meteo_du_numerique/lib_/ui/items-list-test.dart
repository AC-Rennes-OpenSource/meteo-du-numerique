import 'package:flutter/material.dart';
import '../cubit/services_numeriques_state.dart';
import '../models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cubit/services_numeriques_cubit.dart';
import '../../models/models.dart';

class ItemsList extends StatelessWidget {
  final List<ServiceNumerique> services;
  final ScrollController? scrollController;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;

  const ItemsList({
    super.key,
    required this.services,
    this.scrollController,
    this.shrinkWrap = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(child: Text('Pas de résultat.')),
      );
    }

    return SliverPadding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: ServiceNumeriqueListTile(
                service: services[index],
              ),
            );
          },
          childCount: services.length,
        ),
      ),
    );
  }
}



class ServiceNumeriqueListTile extends StatelessWidget {
  final ServiceNumerique service;

  const ServiceNumeriqueListTile({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesNumeriquesCubit, ServicesNumeriquesState>(
      builder: (context, state) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kIsWeb ? 2 : 10.0),
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(
              color: serviceTextColor(service.qualiteDeService?.id ?? 0, isDarkMode),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildHeader(isDarkMode),
              _buildQualiteDeService(isDarkMode),
              _buildDescription(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: kIsWeb
          ? Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(child: _getIcon(isDarkMode)),
          ),
          const SizedBox(height: 8),
          Text(
            service.libelle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: kIsWeb ? 26.0 : 22,
              color: serviceTextColor(service.qualiteDeService?.id ?? 0, isDarkMode),
            ),
          ),
        ],
      )
          : Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              service.libelle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: kIsWeb ? 26.0 : 22,
                color: serviceTextColor(service.qualiteDeService?.id ?? 0, isDarkMode),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 0,
            bottom: 0,
            child: _getIcon(isDarkMode),
          ),
        ],
      ),
    );
  }

  Widget _buildQualiteDeService(bool isDarkMode) {
    return Container(
      color: serviceColor(service.qualiteDeService?.id ?? 0, isDarkMode),
      height: 35,
      width: double.infinity,
      child: Center(
        child: Text(
          service.qualiteDeService?.libelle ?? 'Non défini',
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: MarkdownBody(
        selectable: true,
        onTapLink: (text, url, title) {
          if (url != null) launchUrl(Uri.parse(url));
        },
        data: service.description,
        styleSheet: MarkdownStyleSheet(
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
    );
  }

  Widget _getIcon(bool isDarkMode) {
    IconData iconData;
    Color iconColor;

    switch (service.qualiteDeService?.id) {
      case 1:
        iconData = Icons.sunny;
        iconColor = isDarkMode ? const Color(0xff3db482) : const Color(0xff247566);
        break;
      case 2:
        iconData = CupertinoIcons.umbrella_fill;
        iconColor = isDarkMode ? const Color(0xffdb8b00) : const Color(0xff945400);
        break;
      case 3:
        iconData = Icons.flash_on;
        iconColor = isDarkMode ? const Color(0xffdb2c66) : const Color(0xff94114e);
        break;
      default:
        return SizedBox();
    }

    return Icon(
      iconData,
      color: iconColor,
      size: kIsWeb ? 30 : 20,
    );
  }

  Color serviceColor(int qualiteDeServiceId, bool isDarkTheme) {
    switch (qualiteDeServiceId) {
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

  Color serviceTextColor(int qualiteDeServiceId, bool isDarkTheme) {
    switch (qualiteDeServiceId) {
      case 1:
        return isDarkTheme ? const Color(0xff3db482) : const Color(0xff247566);
      case 2:
        return isDarkTheme ? const Color(0xffdb8b00) : const Color(0xff945400);
      case 3:
        return isDarkTheme ? const Color(0xffdb2c66) : const Color(0xff94114e);
      default:
        return Colors.grey;
    }
  }
}

