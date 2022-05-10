import 'dart:async';

import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:movement_analyzer/bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class AccelerometerBloc extends Bloc {
  final _sensorEventController = BehaviorSubject<SensorEvent>();
  StreamSubscription<SensorEvent>? _accelerometerStreamSubscription;
  bool _initialized = false;

  @override
  Stream<SensorEvent> get stream => _sensorEventController.stream;

  // 初期化に非同期処理が必要なのでFactoryパターンでのインスタンス生成を強制する
  AccelerometerBloc._();

  static Future<AccelerometerBloc> create(
      {Duration duration = const Duration(seconds: 3)}) async {
    final instance = AccelerometerBloc._();
    await instance._init();
    return instance;
  }

  Future<void> _init() async {
    if (_initialized || await checkPermission() == false) {
      return;
    }

    final stream = await SensorManager().sensorUpdates(
      sensorId: Sensors.LINEAR_ACCELERATION,
      interval: Sensors.SENSOR_DELAY_GAME,
    );

    _accelerometerStreamSubscription =
        stream.asBroadcastStream().listen((SensorEvent sensorEvent) {
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
