import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iptracker/core/network/dio_client.dart';
import 'package:iptracker/core/services/ip_service_provider.dart';
import 'package:iptracker/features/ip_lookup/repository/ip_repository.dart';
import 'package:iptracker/features/ip_lookup/view_models/home_view_model.dart';
import 'package:iptracker/features/ip_lookup/view_models/map_view_model.dart';
import 'package:iptracker/features/ip_lookup/screens/home_screen.dart';
import 'package:iptracker/features/ip_lookup/screens/map_screen.dart';
import 'package:iptracker/features/ip_lookup/models/ip_data.dart';
import 'package:iptracker/routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Core services
        Provider<DioClient>(create: (_) => DioClient()),
        
        // Service provider for IP services
        ChangeNotifierProvider<IPServiceProvider>(
          create: (context) => IPServiceProvider(
            dioClient: context.read<DioClient>(),
          ),
        ),
        
        // Repository
        Provider<IPRepository>(
          create: (context) => IPRepository(
            serviceProvider: context.read<IPServiceProvider>(),
          ),
        ),
        
        // ViewModels
        ChangeNotifierProvider<HomeViewModel>(
          create: (context) => HomeViewModel(
            ipRepository: context.read<IPRepository>(),
          ),
        ),
        ChangeNotifierProvider<MapViewModel>(
          create: (_) => MapViewModel(),
        ),
      ],
      child: const IPTrackerApp(),
    ),
  );
}

class IPTrackerApp extends StatelessWidget {
  const IPTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IPTracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: Routes.home,
      routes: {
        Routes.home: (_) => const HomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == Routes.map) {
          final ipData = settings.arguments as IPData;
          return MaterialPageRoute(
            builder: (_) => MapScreen(
              viewModel: context.read<MapViewModel>(),
              ipData: ipData,
            ),
          );
        }
        return null;
      },
    );
  }
}