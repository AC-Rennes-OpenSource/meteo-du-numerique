import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meteo_du_numerique/core/config/firebase_config.dart';
import 'package:meteo_du_numerique/data/services/firebase_service.dart';
import 'package:meteo_du_numerique/domain/blocs/theme/theme_bloc.dart';
import 'package:meteo_du_numerique/domain/blocs/theme/theme_state.dart';

import '../../domain/blocs/digital_services/digital_services_bloc.dart';
import '../../domain/blocs/forecasts/forecasts_bloc.dart';
import '../../domain/blocs/search/search_bloc.dart';
import '../../domain/cubits/app_cubit.dart';
import '../features/home/pages/home_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final GetIt _serviceLocator = GetIt.instance;
  late ThemeBloc _themeBloc;
  bool _isConfigLoaded = false;
  bool _showForecasts = true; // Default to true, will be updated by remote config
  
  @override
  void initState() {
    super.initState();
    _themeBloc = ThemeBloc();
    _initializeApp();
    
    // Listen for notification taps
    _serviceLocator<FirebaseService>().onNotificationTap.listen(_handleNotificationTap);
  }
  
  Future<void> _initializeApp() async {
    try {
      // Initialize remote config
      final remoteConfig = await FirebaseConfig.initRemoteConfig();
      
      setState(() {
        _showForecasts = remoteConfig.getBool('show_forecasts');
        _isConfigLoaded = true;
      });
    } catch (e) {
      debugPrint('Error loading configuration: $e');
      setState(() {
        _isConfigLoaded = true; // Consider it loaded to not block the app
      });
    }
  }
  
  void _handleNotificationTap(dynamic message) {
    // Handle notification tap by navigating to appropriate screen or showing dialog
    debugPrint('Notification tapped: $message');
    
    // You can implement specific navigation or actions here
    // For example:
    // if (message.data.containsKey('service_id')) {
    //   Navigator.of(context).push(MaterialPageRoute(
    //     builder: (_) => ServiceDetailPage(serviceId: message.data['service_id'])
    //   ));
    // }
  }
  
  @override
  void dispose() {
    _themeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while configuration is being loaded
    if (!_isConfigLoaded) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _themeBloc),
        BlocProvider(create: (_) => SearchBloc()),
        BlocProvider(create: (_) => _serviceLocator<DigitalServicesBloc>()),
        BlocProvider(create: (_) => _serviceLocator<ForecastsBloc>()),
        BlocProvider(create: (_) => _serviceLocator<AppCubit>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: const Locale.fromSubtags(languageCode: "fr", countryCode: "FR"),
            title: 'Météo du Numérique',
            theme: ThemeBloc.lightTheme,
            darkTheme: ThemeBloc.darkTheme,
            themeMode: state.themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}