import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:movement_analyzer/accelerometer_bloc.dart';
import 'package:movement_analyzer/parameter_display.dart';

@immutable
class AccelerometerDisplay extends ParameterDisplay<AccelerometerBloc> {
  const AccelerometerDisplay({Key? key}) : super(key: key);

  @override
  Text getParameterText(param) {
    final sensorEvent = param;
    if (sensorEvent is SensorEvent) {
      final x = sensorEvent.data[0];
      final y = sensorEvent.data[1];
      final z = sensorEvent.data[2];
      return Text('x: $x, y: $y, z: $z');
    } else {
      return const Text('');
    }
  }
}
