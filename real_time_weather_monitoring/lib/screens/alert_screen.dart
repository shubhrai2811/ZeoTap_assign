import 'package:flutter/material.dart';
import '../models/temperature_alert.dart';
import '../services/alert_service.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<TemperatureAlert> _alerts = [];

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    final alerts = await AlertService.getAlerts();
    setState(() {
      _alerts = alerts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Alerts'),
      ),
      body: ListView.builder(
        itemCount: _alerts.length,
        itemBuilder: (context, index) {
          final alert = _alerts[index];
          return ListTile(
            title: Text(alert.city),
            subtitle:
                Text('Threshold: ${alert.threshold.toStringAsFixed(1)}°C'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await AlertService.deleteAlert(alert.city);
                _loadAlerts();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAlertDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddAlertDialog(BuildContext context) async {
    final TextEditingController cityController = TextEditingController();
    final TextEditingController thresholdController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Temperature Alert'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              TextField(
                controller: thresholdController,
                decoration: const InputDecoration(labelText: 'Threshold (°C)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final city = cityController.text.trim();
                final threshold = double.tryParse(thresholdController.text);
                if (city.isNotEmpty && threshold != null) {
                  await AlertService.saveAlert(
                      TemperatureAlert(city: city, threshold: threshold));
                  Navigator.pop(context);
                  _loadAlerts();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
