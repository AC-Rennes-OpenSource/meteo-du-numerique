import 'package:get_it/get_it.dart';
import 'package:meteo_du_numerique/services/preferences_cubit.dart';
import 'api_strapi_service.dart';
import 'api_mapper.dart';
import 'data_cubit.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Enregistrer les dépendances
  locator.registerLazySingleton(() => ApiMapper());
  locator.registerLazySingleton(() => ApiStrapiService(
        baseUrl: "https://qt.toutatice.fr/strapi5/api",
        mapper: locator<ApiMapper>(),
      ));

  // Enregistrer le DataCubit
  locator.registerFactory<DataCubit>(() => DataCubit(apiService: locator<ApiStrapiService>()));

  // Enregistrer le PreferencesCubit
  locator.registerLazySingleton<PreferencesCubit>(() => PreferencesCubit());
}


