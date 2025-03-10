import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/blocs/digital_services/digital_services_bloc.dart';
import '../../../../domain/blocs/digital_services/digital_services_state.dart';
import 'service_card.dart';

class ServicesList extends StatelessWidget {
  const ServicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DigitalServicesBloc, DigitalServicesState>(
      builder: (context, state) {
        if (state is DigitalServicesLoading) {
          return SliverFillRemaining(
              child: Center(
            child: Platform.isIOS ? const Center(child: CupertinoActivityIndicator(radius: 15)) : const Center(child: CircularProgressIndicator()),
          ));
        } else if (state is DigitalServicesLoaded) {
          final services = state.services;

          if (services.isEmpty) {
            return const SliverFillRemaining(
              child: Center(
                child: Text('Pas de résultat'),
              ),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == services.length) {
                  // Add bottom padding after the last item
                  return const SizedBox(height: 100);
                }
                final service = services[index];
                return ServiceCard(service: service);
              },
              childCount: services.length + 1, // +1 for the padding widget
            ),
          );
        } else if (state is DigitalServicesError) {
          return SliverFillRemaining(
            child: Center(
              child: Center(child: Text('Un problème de connexion est survenu.')),
            ),
          );
        } else {
          return const SliverFillRemaining(
            child: Center(
              child: Center(child: Text('Chargement...')),
            ),
          );
        }
      },
    );
  }
}
