import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo_du_numerique/ui/widgets/service_card_widget.dart';

import '../../bloc/items_bloc/services_num_bloc.dart';
import '../../bloc/items_bloc/services_num_state.dart';

class ItemsList extends StatelessWidget {
  const ItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    // context.read<ServicesNumBloc>().add(FetchServicesNumEvent());

    return BlocBuilder<ServicesNumBloc, ServicesNumState>(
      builder: (context, state) {
        if (state is ServicesNumLoading) {
          return SliverFillRemaining(
            child: Platform.isIOS
                ? const Center(child: CupertinoActivityIndicator(radius: 15))
                : const Center(child: CircularProgressIndicator()),
          );
        } else if (state is ServicesNumLoaded) {
          if (state.servicesList.isEmpty) {
            return const SliverFillRemaining(
              child: Center(child: Text('Pas de résultat.')),
            );
          } else {
            return SliverPadding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: ServiceCardWidget(
                        service: state.servicesList[index],
                      ),
                    );
                  },
                  childCount: state.servicesList.length,
                ),
              ),
            );
          }
        } else if (state is ServicesNumError) {
          return const SliverFillRemaining(
            child: Center(child: Text('Un problème de connexion est survenu.')),
          );
        }
        return const SliverFillRemaining(
          child: Center(child: Text('Chargement...')),
        );
      },
    );
  }
}