import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:movement_analyzer/bloc.dart';

class GeolocatorBloc extends Bloc {
  final _loadingController = StreamController<bool>();
  final _positionController = StreamController<Position>();

  late final StreamSubscription<Position> _currentPositionSubscription;

  @override
  Stream<Position> get stream => _positionController.stream;
  Stream<bool> get isLoading => _loadingController.stream;

  GeolocatorBloc() {
    _subscribeTakeCurrentPosition();
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

  void _subscribeTakeCurrentPosition() async {
    if (await _checkPermission() == false) {
      return;
    }
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
    );
    _currentPositionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
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
  }
}
