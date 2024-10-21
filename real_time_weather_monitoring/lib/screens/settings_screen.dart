import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../widgets/temperature_unit_toggle.dart';
import '../providers/weather_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _useCelsius = true;
  double _temperatureThreshold = 35.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _useCelsius = prefs.getBool('useCelsius') ?? true;
      _temperatureThreshold = prefs.getDouble('temperatureThreshold') ?? 35.0;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useCelsius', _useCelsius);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Temperature Unit',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Center(
              child: TemperatureUnitToggle(
                useCelsius: _useCelsius,
                onChanged: (value) {
                  setState(() {
                    _useCelsius = value;
                    Provider.of<WeatherProvider>(context, listen: false)
                        .setTemperatureUnit(value);
                    _saveSettings();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
