import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherApiService {
  final String apiKey =
      '354497e8a06ea52e1f42d37e2ce08191'; // this is my api key( should be hidden, but for submission i have hardcoded it)
  final List<String> cities = [
    'Delhi',
    'Mumbai',
    'Chennai',
    'Bangalore',
    'Kolkata',
    'Hyderabad'
  ];

  Future<List<Weather>> fetchWeatherData() async {
    List<Weather> weatherData = [];

    for (String city in cities) {
      final weather = await fetchWeatherForCity(city);
      if (weather != null) {
        weatherData.add(weather);
      }
    }

    return weatherData;
  }

  Future<Weather?> fetchWeatherForCity(String city) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city,in&appid=$apiKey'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Weather.fromJson(jsonData, city);
      } else {
        print('Failed to load weather data for $city: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching weather data for $city: $e');
      return null;
    }
  }
}
