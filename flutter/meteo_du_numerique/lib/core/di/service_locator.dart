import 'package:get_it/get_it.dart';

import '../../data/repositories/digital_services_repository.dart';
import '../../data/repositories/forecasts_repository.dart';
import '../../data/services/firebase_service.dart';
import '../../data/services/notification_service.dart';
import '../../data/sources/api_client.dart';
import '../../domain/blocs/digital_services/digital_services_bloc.dart';
import '../../domain/blocs/forecasts/forecasts_bloc.dart';
import '../../domain/blocs/search/search_bloc.dart';
import '../../domain/cubits/app_cubit.dart';
import '../../domain/blocs/theme/theme_bloc.dart';
import '../config/firebase_config.dart';

final GetIt serviceLocator = GetIt.instance;

/// Initialize all dependencies for the application
Future<void> setupServiceLocator() async {
  // Services
  serviceLocator.registerLazySingleton<FirebaseService>(() => FirebaseService());
  serviceLocator.registerLazySingleton<NotificationService>(() => NotificationService());
  serviceLocator.registerLazySingleton<FirebaseConfig>(() => FirebaseConfig());
  
  // API
  serviceLocator.registerLazySingleton<ApiClient>(() => ApiClient());
  
  // Repositories
  serviceLocator.registerLazySingleton<DigitalServicesRepository>(
    () => DigitalServicesRepositoryImpl(serviceLocator())
  );
  
  serviceLocator.registerLazySingleton<ForecastsRepository>(
    () => ForecastsRepositoryImpl(serviceLocator())
  );
  
  // Blocs and Cubits
  serviceLocator.registerFactory<ThemeBloc>(() => ThemeBloc());
  
  serviceLocator.registerFactory<DigitalServicesBloc>(
    () => DigitalServicesBloc(
      repository: serviceLocator<DigitalServicesRepository>(), 
      useMockData: false // Use the real API from Strapi
    )
  );
  
  serviceLocator.registerFactory<ForecastsBloc>(
    () => ForecastsBloc(forecastsRepository: serviceLocator<ForecastsRepository>())
  );
  
  serviceLocator.registerFactory<SearchBloc>(() => SearchBloc());
  
  serviceLocator.registerFactory<AppCubit>(() => AppCubit());
  
  // Initialize Firebase messaging
  await serviceLocator<FirebaseService>().initialize();
}