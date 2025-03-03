import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/blocs/digital_services/digital_services_bloc.dart';
import '../../../../domain/blocs/digital_services/digital_services_state.dart';
import 'service_card.dart';

class ServicesList extends StatelessWidget {
  const ServicesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DigitalServicesBloc, DigitalServicesState>(
      builder: (context, state) {
        if (state is DigitalServicesLoading) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is DigitalServicesLoaded) {
          final services = state.services;
          
          if (services.isEmpty) {
            return const SliverFillRemaining(
              child: Center(
                child: Text('No services found'),
              ),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final service = services[index];
                return ServiceCard(service: service);
              },
              childCount: services.length,
            ),
          );
        } else if (state is DigitalServicesError) {
          return SliverFillRemaining(
            child: Center(
              child: Text('Error: ${state.message}'),
            ),
          );
        } else {
          return const SliverFillRemaining(
            child: Center(
              child: Text('Unknown state'),
            ),
          );
        }
      },
    );
  }
}