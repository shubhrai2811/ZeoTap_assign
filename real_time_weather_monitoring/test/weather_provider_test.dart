import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:real_time_weather_monitoring/models/weather.dart';
import 'package:real_time_weather_monitoring/providers/weather_provider.dart';
import 'package:real_time_weather_monitoring/services/weather_api_service.dart';
import 'package:real_time_weather_monitoring/services/database_service.dart';

class MockWeatherApiService extends Mock implements WeatherApiService {}

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late WeatherProvider weatherProvider;
  late MockWeatherApiService mockApiService;
  late MockDatabaseService mockDatabaseService;

  setUp(() {
    mockApiService = MockWeatherApiService();
    mockDatabaseService = MockDatabaseService();
    weatherProvider = WeatherProvider(
      apiService: mockApiService,
      databaseService: mockDatabaseService,
    );
  });

  test('fetchAndStoreWeatherData updates currentWeather', () async {
    final mockWeatherData = [
      Weather(
          city: 'TestCity',
          temperature: 25.0,
          feelsLike: 26.0,
          condition: 'Sunny',
          humidity: 50.0,
          windSpeed: 10.0,
          timestamp: DateTime.now()),
    ];

    when(mockApiService.fetchWeatherData())
        .thenAnswer((_) async => mockWeatherData);

    await weatherProvider.fetchAndStoreWeatherData();

    expect(weatherProvider.currentWeather, equals(mockWeatherData));
    verify(mockDatabaseService.insertWeather(mockWeatherData[0])).called(1);
  });

  test('getDailySummary returns correct summary', () async {
    final mockDailyData = [
      Weather(
          city: 'TestCity',
          temperature: 20.0,
          feelsLike: 21.0,
          condition: 'Sunny',
          humidity: 50.0,
          windSpeed: 10.0,
          timestamp: DateTime.now()),
      Weather(
          city: 'TestCity',
          temperature: 25.0,
          feelsLike: 26.0,
          condition: 'Cloudy',
          humidity: 50.0,
          windSpeed: 10.0,
          timestamp: DateTime.now()),
      Weather(
          city: 'TestCity',
          temperature: 22.0,
          feelsLike: 23.0,
          condition: 'Sunny',
          humidity: 50.0,
          windSpeed: 10.0,
          timestamp: DateTime.now()),
    ];

    final testDate = DateTime.now();
    when(mockDatabaseService.getWeatherData('TestCity', testDate))
        .thenAnswer((_) async => mockDailyData);

    final summary = await weatherProvider.getDailySummary('TestCity', testDate);

    expect(summary['average'], equals(22.333333333333332));
    expect(summary['max'], equals(25.0));
    expect(summary['min'], equals(20.0));
    expect(summary['dominant_condition'], equals('Sunny'));
  });
}
