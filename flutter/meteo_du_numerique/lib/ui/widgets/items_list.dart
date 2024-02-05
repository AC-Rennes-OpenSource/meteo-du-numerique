import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/bloc/items_bloc/items_event.dart';
import 'package:meteo_du_numerique/ui/widgets/service_card_widget.dart';

import '../../bloc/items_bloc/items_bloc.dart';
import '../../bloc/items_bloc/items_state.dart';

class ItemsList extends StatelessWidget {
  const ItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ItemsBloc>().add(FetchItemsEvent());

    return BlocBuilder<ItemsBloc, ItemsState>(
      builder: (context, state) {
        if (state is ItemsLoading) {
          return SliverFillRemaining(
            child: Platform.isIOS
                ? const Center(
                child: CupertinoActivityIndicator(
                  radius: 15,
                ))
                : const Center(child: CircularProgressIndicator()),
          );
        } else if (state is ItemsLoaded) {
          return SliverPadding(
            padding: const EdgeInsets.only(top: 8.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: ServiceCardWidget(service: state.items[index]),
                    ),
                childCount: state.items.length,
              ),
            ),
          );
        } else if (state is ItemsError) {
          return const SliverFillRemaining(
            child: Center(child: Text('Pas de résultats.')),
          );
        }
        return const SliverFillRemaining(
          child: Center(child: Text('Pas de résultat.')),
        );
      },
    );
  }
}
