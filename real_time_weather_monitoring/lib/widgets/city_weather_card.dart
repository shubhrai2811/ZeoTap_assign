import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../providers/weather_provider.dart';
import 'package:provider/provider.dart';

class CityWeatherCard extends StatelessWidget {
  final Weather weather;

  const CityWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weather.city,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
                'Temperature: ${weatherProvider.convertTemperature(weather.temperature).toStringAsFixed(1)}${weatherProvider.getTemperatureUnit()}'),
            Text(
                'Feels like: ${weatherProvider.convertTemperature(weather.feelsLike).toStringAsFixed(1)}${weatherProvider.getTemperatureUnit()}'),
            Text('Condition: ${weather.condition}'),
            Text('Last updated: ${weather.timestamp.toString()}'),
          ],
        ),
      ),
    );
  }
}
