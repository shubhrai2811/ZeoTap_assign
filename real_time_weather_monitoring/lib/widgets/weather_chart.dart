import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/weather_provider.dart';
import '../models/weather.dart';

class WeatherChart extends StatelessWidget {
  final WeatherProvider weatherProvider;

  const WeatherChart({super.key, required this.weatherProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 &&
                      index < weatherProvider.currentWeather.length) {
                    return Text(weatherProvider.currentWeather[index].city
                        .substring(0, 3));
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: weatherProvider.currentWeather.length.toDouble() - 1,
          minY: _getMinTemperature(weatherProvider.currentWeather),
          maxY: _getMaxTemperature(weatherProvider.currentWeather),
          lineBarsData: [
            LineChartBarData(
              spots: _createSpots(weatherProvider.currentWeather),
              isCurved: true,
              color: Colors.blue,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _createSpots(List<Weather> weatherData) {
    return weatherData
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(),
            weatherProvider.convertTemperature(entry.value.temperature)))
        .toList();
  }

  double _getMinTemperature(List<Weather> weatherData) {
    return weatherProvider.convertTemperature(
        weatherData.map((w) => w.temperature).reduce((a, b) => a < b ? a : b) -
            5);
  }

  double _getMaxTemperature(List<Weather> weatherData) {
    return weatherProvider.convertTemperature(
        weatherData.map((w) => w.temperature).reduce((a, b) => a > b ? a : b) +
            5);
  }
}
