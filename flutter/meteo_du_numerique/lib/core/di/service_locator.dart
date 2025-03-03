import 'package:get_it/get_it.dart';

import '../../data/repositories/digital_services_repository.dart';
import '../../data/repositories/forecasts_repository.dart';
import '../../data/sources/api_client.dart';
import '../../domain/blocs/digital_services/digital_services_bloc.dart';
import '../../domain/blocs/forecasts/forecasts_bloc.dart';
import '../../domain/blocs/search/search_bloc.dart';
import '../../domain/cubits/app_cubit.dart';
import '../../domain/blocs/theme/theme_bloc.dart';

final GetIt serviceLocator = GetIt.instance;

/// Initialize all dependencies for the application
Future<void> setupServiceLocator() async {
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
    () => ForecastsBloc()
  );
  
  serviceLocator.registerFactory<SearchBloc>(() => SearchBloc());
  
  serviceLocator.registerFactory<AppCubit>(() => AppCubit());
}