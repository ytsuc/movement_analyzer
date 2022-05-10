import 'dart:async';

//import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:movement_analyzer/bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class GeolocatorBloc extends Bloc {
  final _positionController = BehaviorSubject<Position>();
  final _timerPositionController = BehaviorSubject<Position>();

  late final StreamSubscription<Position> _currentPositionSubscription;

  @override
  Stream<Position> get stream => _positionController.stream;
  Stream<Position> get timerStream => _timerPositionController.stream;
  Timer? _timer;

  // 初期化に非同期処理が必要なのでFactoryパターンでのインスタンス生成を強制する
  GeolocatorBloc._();

  static Future<GeolocatorBloc> create(
      {Duration duration = const Duration(seconds: 5)}) async {
    final instance = GeolocatorBloc._();
    await instance._subscribeTakeCurrentPosition();
    instance._timer = Timer.periodic(duration, instance._timerFunction);
    return instance;
  }

  void _timerFunction(Timer timer) async {
    final pos = await _getCurrentPosition();
    if (pos is Position) {
      _timerPositionController.sink.add(pos);
    }
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
      _positionController.sink.add(position);
    });
  }

  Future<Position?> _getCurrentPosition() async {
    if (await _checkPermission() == false) {
      return null;
    }
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return currentPosition;
  }

  void changeTimerInterval(int seconds) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: seconds), _timerFunction);
  }

  void resumeListenCurrentPosition() {
    _currentPositionSubscription.resume();
  }

  void pauseListenCurrentPosition() {
    _currentPositionSubscription.pause();
  }

  @override
  void dispose() {
    _positionController.close();
    _currentPositionSubscription.cancel();
    _timerPositionController.close();
  }
}
