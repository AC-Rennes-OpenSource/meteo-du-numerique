import 'package:get_it/get_it.dart';

import '../../data/repositories/digital_services_repository.dart';
import '../../data/repositories/forecasts_repository.dart';
import '../../data/services/notification_service.dart';
import '../../data/sources/api_client.dart';
import '../../domain/blocs/digital_services/digital_services_bloc.dart';
import '../../domain/blocs/forecasts/forecasts_bloc.dart';
import '../../domain/cubits/app_cubit.dart';
import '../../domain/cubits/search_cubit.dart';
import '../../domain/cubits/theme_cubit.dart';
import '../config/firebase_config.dart';

final GetIt serviceLocator = GetIt.instance;

/// Initialize all dependencies for the application
Future<void> setupServiceLocator() async {
  // Config and services
  serviceLocator.registerLazySingleton<FirebaseConfig>(() => FirebaseConfig());

  // Register NotificationService as an async singleton
  serviceLocator.registerSingletonAsync<NotificationService>(() async {
    final service = NotificationService();
    await service.initialize();
    return service;
  });

  // API
  serviceLocator.registerLazySingleton<ApiClient>(() => ApiClient());

  // Repositories
  serviceLocator.registerLazySingleton<DigitalServicesRepository>(() => DigitalServicesRepositoryImpl(serviceLocator()));

  serviceLocator.registerLazySingleton<ForecastsRepository>(() => ForecastsRepositoryImpl(serviceLocator()));

  // Blocs and Cubits
  serviceLocator.registerFactory<ThemeCubit>(() => ThemeCubit());

  serviceLocator.registerFactory<DigitalServicesBloc>(
      () => DigitalServicesBloc(repository: serviceLocator<DigitalServicesRepository>(), useMockData: false // Use the real API from Strapi
          ));

  serviceLocator.registerFactory<ForecastsBloc>(() => ForecastsBloc(forecastsRepository: serviceLocator<ForecastsRepository>()));

  serviceLocator.registerFactory<SearchCubit>(() => SearchCubit());

  serviceLocator.registerFactory<AppCubit>(() => AppCubit());

  // Wait for all async singletons to be initialized
  await serviceLocator.allReady();
}
