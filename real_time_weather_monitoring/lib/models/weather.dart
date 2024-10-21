import 'package:intl/intl.dart';

class Weather {
  final String city;
  final double temperature;
  final double feelsLike;
  final String condition;
  final double humidity;
  final double windSpeed;
  final DateTime timestamp;

  Weather({
    required this.city,
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.timestamp,
  });

  factory Weather.fromJson(Map<String, dynamic> json, String city) {
    return Weather(
      city: city,
      temperature: (json['main']['temp'] as num).toDouble() - 273.15,
      feelsLike: (json['main']['feels_like'] as num).toDouble() - 273.15,
      condition: json['weather'][0]['main'] as String,
      humidity: (json['main']['humidity'] as num).toDouble(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      timestamp:
          DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
    );
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      city: map['city'],
      temperature: map['temperature'],
      feelsLike: map['feels_like'],
      condition: map['condition'],
      humidity: map['humidity'],
      windSpeed: map['wind_speed'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'temperature': temperature,
      'feels_like': feelsLike,
      'condition': condition,
      'humidity': humidity,
      'wind_speed': windSpeed,
      'timestamp': DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'temperature': temperature,
      'condition': condition,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
