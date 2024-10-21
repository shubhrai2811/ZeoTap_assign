import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/weather.dart';
import '../models/temperature_alert.dart';

class AlertService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notifications.initialize(initializationSettings);
  }

  static Future<void> checkAndSendAlerts(Weather weather) async {
    final alerts = await getAlerts();
    for (var alert in alerts) {
      if (weather.city == alert.city && weather.temperature > alert.threshold) {
        _sendNotification(
          'Temperature Alert',
          'Temperature in ${weather.city} has exceeded ${alert.threshold.toStringAsFixed(1)}°C',
        );
      }
    }
  }

  static void _sendNotification(String title, String body) {
    // Use a plugin like flutter_local_notifications to send notifications
    // This should be implemented to work in the background
  }

  static Future<List<TemperatureAlert>> getAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    final alertsJson = prefs.getString('temperatureAlerts') ?? '[]';
    final List<dynamic> alertsList = json.decode(alertsJson);
    return alertsList.map((alert) => TemperatureAlert.fromJson(alert)).toList();
  }

  static Future<void> saveAlert(TemperatureAlert alert) async {
    final prefs = await SharedPreferences.getInstance();
    final alerts = await getAlerts();
    final existingAlertIndex = alerts
        .indexWhere((a) => a.city.toLowerCase() == alert.city.toLowerCase());

    if (existingAlertIndex != -1) {
      alerts[existingAlertIndex] = alert;
    } else {
      alerts.add(alert);
    }

    await prefs.setString('temperatureAlerts',
        json.encode(alerts.map((a) => a.toJson()).toList()));
  }

  static Future<void> deleteAlert(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final alerts = await getAlerts();
    alerts
        .removeWhere((alert) => alert.city.toLowerCase() == city.toLowerCase());
    await prefs.setString('temperatureAlerts',
        json.encode(alerts.map((a) => a.toJson()).toList()));
  }
}
