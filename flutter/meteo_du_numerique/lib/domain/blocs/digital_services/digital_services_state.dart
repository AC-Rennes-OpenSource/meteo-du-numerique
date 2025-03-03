import 'package:equatable/equatable.dart';

import '../../../data/models/digital_service.dart';

abstract class DigitalServicesState extends Equatable {
  const DigitalServicesState();
  
  @override
  List<Object?> get props => [];
}

class DigitalServicesInitial extends DigitalServicesState {}

class DigitalServicesLoading extends DigitalServicesState {}

class DigitalServicesLoaded extends DigitalServicesState {
  final List<DigitalService> services;
  final DateTime? lastUpdate;
  
  const DigitalServicesLoaded({
    required this.services, 
    this.lastUpdate
  });
  
  @override
  List<Object?> get props => [services, lastUpdate];
}

class DigitalServicesError extends DigitalServicesState {
  final String message;

  const DigitalServicesError({required this.message});
  
  @override
  List<Object> get props => [message];
}