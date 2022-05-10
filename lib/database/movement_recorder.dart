import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:movement_analyzer/bloc/accelerometer_bloc.dart';
import 'package:movement_analyzer/bloc/geolocator_bloc.dart';
import 'package:movement_analyzer/database/database_manager.dart';
import 'package:movement_analyzer/database/movement.dart';

class MovementRecorder {
  final AccelerometerBloc _accBloc;
  final GeolocatorBloc _geoBloc;
  final DatabaseManager _databaseManager;
  SensorEvent? _latestSendorEvent;
  String userId;

  MovementRecorder(
      this.userId, this._accBloc, this._geoBloc, this._databaseManager) {
    _accBloc.stream.listen((SensorEvent event) {
      _latestSendorEvent = event;
    });

    _geoBloc.timerStream.listen((Position event) {
      onListenGeolocation(event);
    });
  }

  Future<void> onListenGeolocation(Position position) async {
    final sensorEvent = _latestSendorEvent;
    if (sensorEvent == null) return;

    _databaseManager.saveMovement(
        Movement(userId: userId, position: position, sensorEvent: sensorEvent));
  }
}
