import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/weather.dart';
import '../services/weather_api_service.dart';
import '../services/database_service.dart';
import '../services/alert_service.dart';

class WeatherProvider extends ChangeNotifier {
  static WeatherProvider? _instance;

  static WeatherProvider get instance {
    _instance ??= WeatherProvider._internal(
      apiService: WeatherApiService(),
      databaseService: DatabaseService(),
    );
    return _instance!;
  }

  factory WeatherProvider.create({
    required WeatherApiService apiService,
    required DatabaseService databaseService,
  }) {
    return WeatherProvider(
      apiService: apiService,
      databaseService: databaseService,
    );
  }

  WeatherProvider({
    required this.apiService,
    required this.databaseService,
  });

  WeatherProvider._internal({
    required this.apiService,
    required this.databaseService,
  });

  final WeatherApiService apiService;
  final DatabaseService databaseService;

  List<Weather> _currentWeather = [];
  List<Weather> get currentWeather => _currentWeather;

  bool _useCelsius = true;
  bool get useCelsius => _useCelsius;

  void setTemperatureUnit(bool useCelsius) {
    _useCelsius = useCelsius;
    notifyListeners();
  }

  double convertTemperature(double celsius) {
    return _useCelsius ? celsius : (celsius * 9 / 5) + 32;
  }

  String getTemperatureUnit() {
    return _useCelsius ? '°C' : '°F';
  }

  Future<void> loadCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cachedWeather');
    if (cachedData != null) {
      final List<dynamic> decodedData = json.decode(cachedData);
      _currentWeather = decodedData
          .map((item) => Weather.fromJson(item, item['city']))
          .toList();
      notifyListeners();
    }
  }

  Future<void> cacheWeatherData() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData =
        json.encode(_currentWeather.map((w) => w.toJson()).toList());
    await prefs.setString('cachedWeather', encodedData);
  }

  Future<List<String>> _loadSavedCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('savedCities') ?? [];
  }

  Future<void> fetchAndStoreWeatherData() async {
    try {
      final cities = await _loadSavedCities();
      if (cities.isEmpty) {
        cities
            .addAll(apiService.cities); // Use default cities if none are saved
      }
      final weatherList = await apiService.fetchWeatherData();

      if (weatherList.isNotEmpty) {
        await databaseService.insertWeatherBatch(weatherList);
        _currentWeather = weatherList;
        notifyListeners();
        await cacheWeatherData();
      } else {
        print('No valid weather data received');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  Future<Map<String, dynamic>> getDailySummary(
      String city, DateTime date) async {
    List<Weather> dailyData = await databaseService.getWeatherData(city, date);

    if (dailyData.isEmpty) {
      return {
        'average': 0.0,
        'max': 0.0,
        'min': 0.0,
        'dominant_condition': 'N/A',
      };
    }

    double sum = 0.0;
    double max = dailyData[0].temperature;
    double min = dailyData[0].temperature;
    Map<String, int> conditionCounts = {};

    for (var weather in dailyData) {
      sum += weather.temperature;
      if (weather.temperature > max) max = weather.temperature;
      if (weather.temperature < min) min = weather.temperature;
      conditionCounts[weather.condition] =
          (conditionCounts[weather.condition] ?? 0) + 1;
    }

    String dominantCondition =
        conditionCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    return {
      'average': sum / dailyData.length,
      'max': max,
      'min': min,
      'dominant_condition': dominantCondition,
    };
  }
}
