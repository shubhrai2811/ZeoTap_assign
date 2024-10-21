import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/weather_provider.dart';
import 'screens/home_screen.dart';
import 'services/background_service.dart';
import 'services/database_service.dart';
import 'services/weather_api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseService = DatabaseService();
  await databaseService.database; // This will initialize the database
  await BackgroundService.initialize();

  final weatherProvider = WeatherProvider.create(
    apiService: WeatherApiService(),
    databaseService: databaseService,
  );
  await weatherProvider.fetchAndStoreWeatherData();

  runApp(MyApp(
      databaseService: databaseService, weatherProvider: weatherProvider));
}

class MyApp extends StatelessWidget {
  final DatabaseService databaseService;
  final WeatherProvider weatherProvider;

  const MyApp({
    super.key,
    required this.databaseService,
    required this.weatherProvider,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: weatherProvider,
      child: MaterialApp(
        title: 'Real-Time Weather Monitoring',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(weatherProvider: weatherProvider),
      ),
    );
  }
}
