import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:movement_analyzer/geolocation_display.dart';
import 'package:movement_analyzer/geolocator_bloc.dart';

@immutable
class TimerGeolocationDisplay extends GeolocationDisplay {
  const TimerGeolocationDisplay({Key? key}) : super(key: key);

  @override
  Text getParameterText(param) {
    if (param is Position) {
      final longitude = param.longitude;
      final latitude = param.latitude;
      final now = DateTime.now().toString();
      return Text('Longitude: $longitude, Latitude: $latitude\n$now');
    } else {
      return const Text('');
    }
  }

  @override
  Stream getStream(GeolocatorBloc bloc) {
    return bloc.timerStream;
  }
}
