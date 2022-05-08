import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:movement_analyzer/accelerometer_bloc.dart';
import 'package:movement_analyzer/parameter_display.dart';

@immutable
class AccelerometerDisplay extends ParameterDisplay<AccelerometerBloc> {
  const AccelerometerDisplay({Key? key}) : super(key: key);

  @override
  Widget getParameterText(param) {
    final sensorEvent = param;
    if (sensorEvent is SensorEvent) {
      final x = sensorEvent.data[0];
      final y = sensorEvent.data[1];
      final z = sensorEvent.data[2];
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('x: $x'),
            Text('y: $y'),
            Text('z: $z'),
          ]);
    } else {
      return const Text('');
    }
  }

  @override
  Stream getStream(AccelerometerBloc bloc) {
    return bloc.stream;
  }
}
