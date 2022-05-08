import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:movement_analyzer/accelerometer_bloc.dart';
import 'package:movement_analyzer/parameter_display.dart';

@immutable
class AccelStateDisplay extends ParameterDisplay<AccelerometerBloc> {
  const AccelStateDisplay({Key? key}) : super(key: key);

  @override
  Text getParameterText(param) {
    var text = '';
    if (param is SensorEvent) {
      final x = param.data[0];
      final y = param.data[1];
      final z = param.data[2];
      final point = sqrt((pow(x, 2) + pow(y, 2) + pow(z, 2)));

      if (point < 2) {
        text = '普通です';
      } else {
        text = '激しい加速！';
      }
    }

    return Text(text);
  }

  @override
  Stream getStream(AccelerometerBloc bloc) {
    return bloc.stream;
  }
}
