import 'dart:async';

import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:movement_analyzer/bloc.dart';

class AccelerometerBloc extends Bloc {
  final _sensorEventController = StreamController<SensorEvent>();
  StreamSubscription<SensorEvent>? _accelerometerStreamSubscription;
  bool _initialized = false;

  @override
  Stream<SensorEvent> get stream => _sensorEventController.stream;

  AccelerometerBloc._();

  static Future<AccelerometerBloc> create() async {
    final instance = AccelerometerBloc._();
    instance._init();
    return instance;
  }

  void _init() async {
    if (_initialized || await checkPermission() == false) {
      return;
    }

    final stream = await SensorManager().sensorUpdates(
      sensorId: Sensors.LINEAR_ACCELERATION,
      interval: Sensors.SENSOR_DELAY_GAME,
    );

    _accelerometerStreamSubscription = stream.listen((SensorEvent sensorEvent) {
      _sensorEventController.sink.add(sensorEvent);
    });

    _initialized = true;
  }

  Future<bool> checkPermission() async {
    return await SensorManager().isSensorAvailable(Sensors.ACCELEROMETER);
  }

  void pauseSubscription() {
    _accelerometerStreamSubscription?.pause();
  }

  void resumeSubscription() {
    _accelerometerStreamSubscription?.resume();
  }

  @override
  void dispose() {
    _sensorEventController.close();
    _accelerometerStreamSubscription?.cancel();
  }
}
