import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/models.dart';
import '../utils.dart';

class PrevisionsList extends StatefulWidget {
  final List<PrevisionGroup> groupedPrevisions;

  const PrevisionsList({super.key, required this.groupedPrevisions});

  @override
  PrevisionsListState createState() => PrevisionsListState();
}

class PrevisionsListState extends State<PrevisionsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.groupedPrevisions.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(child: Text('Pas de résultat.')),
      );
    }

    return SliverToBoxAdapter(
      child: ExpansionPanelList(
        elevation: 1,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            widget.groupedPrevisions[index].isExpanded = isExpanded;
          });
        },
        expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 8.0),
        children: widget.groupedPrevisions.map((group) {
          return ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(title: Text(group.dateDebut));
            },
            body: Column(
              children: group.previsions.map((prevision) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: PrevisionTile(prevision: prevision),
                );
              }).toList(),
            ),
            isExpanded: group.isExpanded,
          );
        }).toList(),
      ),
    );
  }
}

class PrevisionTile extends StatelessWidget {
  final Prevision prevision;

  const PrevisionTile({super.key, required this.prevision});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: _categoryColor(prevision.categoryCouleur)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildHeader(),
          _buildCategoryBanner(),
          _buildDate(),
          _buildDescription(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Text(
        prevision.libelle,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: _categoryColor(prevision.categoryCouleur),
        ),
      ),
    );
  }

  Widget _buildCategoryBanner() {
    return Container(
      color: _categoryColor(prevision.categoryCouleur),
      height: 35,
      width: double.infinity,
      child: Center(
        child: Text(
          prevision.categoryNom ?? 'Non catégorisé',
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDate() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        Utils.formatDate1(prevision.dateDebut),
        style: const TextStyle(fontWeight: FontWeight.bold),
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
        data: prevision.description ?? '',
      ),
    );
  }

  Color _categoryColor(String? color) {
    switch (color?.toLowerCase()) {
      case 'orange':
        return const Color(0xFFD17010);
      case 'jaune':
        return const Color(0xFFC7A213);
      case 'vert':
        return const Color(0xff63BAAB);
      case 'bleu':
        return const Color(0xff28619A);
      case 'rose':
        return const Color(0xffC25452);
      default:
        return Colors.grey;
    }
  }
}
