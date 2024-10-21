import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../models/weather.dart';

class WeatherSummaryScreen extends StatelessWidget {
  const WeatherSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weatherData = weatherProvider.currentWeather;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Summary'),
      ),
      body: weatherData.isEmpty
          ? const Center(child: Text('No weather data available'))
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildTemperatureChart(weatherData, context),
                  const SizedBox(height: 20),
                  _buildHumidityChart(weatherData),
                  const SizedBox(height: 20),
                  _buildWindSpeedChart(weatherData),
                ],
              ),
            ),
    );
  }

  Widget _buildTemperatureChart(
      List<Weather> weatherData, BuildContext context) {
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    return _buildChart(
      weatherData,
      'Temperature (${weatherProvider.getTemperatureUnit()})',
      Colors.red,
      (weather) => weatherProvider.convertTemperature(weather.temperature),
    );
  }

  Widget _buildHumidityChart(List<Weather> weatherData) {
    return _buildChart(
      weatherData,
      'Humidity (%)',
      Colors.blue,
      (weather) => weather.humidity,
    );
  }

  Widget _buildWindSpeedChart(List<Weather> weatherData) {
    return _buildChart(
      weatherData,
      'Wind Speed (m/s)',
      Colors.green,
      (weather) => weather.windSpeed,
    );
  }

  Widget _buildChart(List<Weather> weatherData, String title, Color color,
      double Function(Weather) getValue) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true, drawVerticalLine: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) =>
                          Text(value.toStringAsFixed(1)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < weatherData.length) {
                          return Text(weatherData[index].city.substring(0, 3),
                              style: const TextStyle(fontSize: 10));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                minX: 0,
                maxX: weatherData.length.toDouble() - 1,
                minY:
                    weatherData.map(getValue).reduce((a, b) => a < b ? a : b) -
                        1,
                maxY:
                    weatherData.map(getValue).reduce((a, b) => a > b ? a : b) +
                        1,
                lineBarsData: [
                  LineChartBarData(
                    spots: weatherData
                        .asMap()
                        .entries
                        .map((entry) =>
                            FlSpot(entry.key.toDouble(), getValue(entry.value)))
                        .toList(),
                    isCurved: true,
                    color: color,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
