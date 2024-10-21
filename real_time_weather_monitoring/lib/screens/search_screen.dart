import 'package:flutter/material.dart';
import '../services/weather_api_service.dart';
import '../models/weather.dart';
import '../widgets/city_weather_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final WeatherApiService _apiService = WeatherApiService();
  Weather? _searchResult;
  bool _isLoading = false;
  String _errorMessage = '';

  void _searchCity(String city) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final weather = await _apiService.fetchWeatherForCity(city);
      setState(() {
        _searchResult = weather;
        _isLoading = false;
        if (weather == null) {
          _errorMessage = 'City not found or error occurred';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred while fetching data';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search City'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter city name',
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: _searchCity,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: const TextStyle(color: Colors.red))
            else if (_searchResult != null)
              CityWeatherCard(weather: _searchResult!),
          ],
        ),
      ),
    );
  }
}
