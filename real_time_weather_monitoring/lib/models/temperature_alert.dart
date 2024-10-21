import 'package:flutter/foundation.dart';

class TemperatureAlert {
  final String city;
  final double threshold;

  TemperatureAlert({
    required this.city,
    required this.threshold,
  });

  Map<String, dynamic> toJson() => {
        'city': city,
        'threshold': threshold,
      };

  factory TemperatureAlert.fromJson(Map<String, dynamic> json) {
    return TemperatureAlert(
      city: json['city'],
      threshold: json['threshold'],
    );
  }
}
