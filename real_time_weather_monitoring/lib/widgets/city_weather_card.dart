import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../providers/weather_provider.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_pallete.dart';

class CityWeatherCard extends StatelessWidget {
  final Weather weather;

  const CityWeatherCard({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: AppPallete.backgroundColor.withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppPallete.borderColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weather.city,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: AppPallete.whiteColor),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Temperature: ${weatherProvider.convertTemperature(weather.temperature).toStringAsFixed(1)}${weatherProvider.getTemperatureUnit()}',
              style: TextStyle(color: AppPallete.whiteColor),
            ),
            Text(
              'Feels like: ${weatherProvider.convertTemperature(weather.feelsLike).toStringAsFixed(1)}${weatherProvider.getTemperatureUnit()}',
              style: TextStyle(color: AppPallete.whiteColor),
            ),
            Text(
              'Condition: ${weather.condition}',
              style: TextStyle(color: AppPallete.whiteColor),
            ),
            Text(
              'Last updated: ${weather.timestamp.toString()}',
              style: TextStyle(color: AppPallete.greyColor),
            ),
          ],
        ),
      ),
    );
  }
}
