import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_weather_monitoring/screens/alert_screen.dart';
import '../providers/weather_provider.dart';
import '../widgets/city_weather_card.dart';
import '../widgets/weather_chart.dart';
import 'settings_screen.dart';
import 'search_screen.dart';
import 'weather_summary_screen.dart';
// import 'alerts_screen.dart';

class HomeScreen extends StatefulWidget {
  final WeatherProvider weatherProvider;

  const HomeScreen({Key? key, required this.weatherProvider}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    await widget.weatherProvider.loadCachedWeather();
    if (widget.weatherProvider.currentWeather.isEmpty) {
      await widget.weatherProvider.fetchAndStoreWeatherData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Weather Monitoring'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.summarize),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeatherSummaryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlertsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => widget.weatherProvider.fetchAndStoreWeatherData(),
        child: Consumer<WeatherProvider>(
          builder: (context, weatherProvider, child) {
            if (weatherProvider.currentWeather.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: weatherProvider.currentWeather.length,
              itemBuilder: (context, index) {
                return CityWeatherCard(
                  weather: weatherProvider.currentWeather[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}