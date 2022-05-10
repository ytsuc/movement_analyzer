import 'dart:math';

import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:geolocator/geolocator.dart';

class Movement {
  String userId;
  double longitude;
  double latitude;
  double acceleration;
  DateTime timestamp;

  factory Movement(
      {required String userId,
      required Position position,
      required SensorEvent sensorEvent}) {
    return Movement.fromDigit(
        userId: userId,
        longitude: position.longitude,
        latitude: position.latitude,
        acceleration: _calcAcceleration(sensorEvent),
        timestamp: DateTime.now());
  }
  Movement.fromDigit(
      {required this.userId,
      required this.longitude,
      required this.latitude,
      required this.acceleration,
      required this.timestamp});

  Map<String, Object> toMap() {
    return {
      'user_id': userId,
      'longitude': longitude,
      'latitude': latitude,
      'acceleration': acceleration,
      'recorded_at': timestamp.toString()
    };
  }

  static double _calcAcceleration(SensorEvent sensorEvent) {
    final x = sensorEvent.data[0];
    final y = sensorEvent.data[1];
    final z = sensorEvent.data[2];

    return sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));
  }
}
