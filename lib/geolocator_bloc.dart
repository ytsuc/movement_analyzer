import 'dart:async';

//import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:movement_analyzer/bloc.dart';
import 'package:rxdart/rxdart.dart';

class GeolocatorBloc extends Bloc {
  final _loadingController = BehaviorSubject<bool>();
  final _positionController = BehaviorSubject<Position>();
  final _tickPositionController = BehaviorSubject<Position>();

  late final StreamSubscription<Position> _currentPositionSubscription;

  @override
  Stream<Position> get stream => _positionController.stream;
  Stream<bool> get isLoading => _loadingController.stream;
  Stream<Position> get tickStream => _tickPositionController.stream;
  // final Timer _ticker = Timer(const Duration(seconds: 5), ()=>

/*
  GeolocatorBloc() {
    _subscribeTakeCurrentPosition();
  }
  */

  GeolocatorBloc._();

  static Future<GeolocatorBloc> create() async {
    final instance = GeolocatorBloc._();
    await instance._subscribeTakeCurrentPosition();
    return instance;
  }

  void sinkCurrentPosition(Position position) {
    _positionController.sink.add(position);
  }

  Future<bool> _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return false;
      }
    }
    return true;
  }

  Future<void> _subscribeTakeCurrentPosition() async {
    if (await _checkPermission() == false) {
      return;
    }

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
    );

    _currentPositionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .asBroadcastStream()
            .listen((Position position) {
      sinkCurrentPosition(position);
    });
  }

  void _takeCurrentPosition() async {
    _loadingController.sink.add(true);
    if (await _checkPermission() == false) {
      _loadingController.sink.add(false);
      return;
    }
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _loadingController.sink.add(false);
    _positionController.sink.add(currentPosition);
  }

  void resumeListenCurrentPosition() {
    _currentPositionSubscription.resume();
  }

  void pauseListenCurrentPosition() {
    _currentPositionSubscription.pause();
  }

  @override
  void dispose() {
    _loadingController.close();
    _positionController.close();
    _currentPositionSubscription.cancel();
  }
}
