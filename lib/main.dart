import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';
import 'utils/app_theme.dart';
import 'viewmodels/search_viewmodel.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'views/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi StorageService (SharedPreferences)
  final storageService = await StorageService.init();
  final apiService = ApiService();

  runApp(
    MyApp(
      storageService: storageService,
      apiService: apiService,
    ),
  );
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  final ApiService apiService;

  const MyApp({
    super.key,
    required this.storageService,
    required this.apiService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherViewModel(
            apiService: apiService,
            storageService: storageService,
          )..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchViewModel(
            apiService: apiService,
            storageService: storageService,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Aplikasi Cuaca Open-Meteo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
