import 'dart:async';
import 'package:workmanager/workmanager.dart';
import 'weather_api_service.dart';
import '../providers/weather_provider.dart';
import '../services/database_service.dart';

const fetchBackgroundTask = "fetchWeatherData";

class BackgroundService {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
    await Workmanager().registerPeriodicTask(
      "1",
      fetchBackgroundTask,
      frequency: const Duration(minutes: 10),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      switch (task) {
        case fetchBackgroundTask:
          final apiService = WeatherApiService();
          final databaseService = DatabaseService();
          final weatherProvider = WeatherProvider.instance;
          await weatherProvider.fetchAndStoreWeatherData();
          break;
      }
      return Future.value(true);
    });
  }
}
