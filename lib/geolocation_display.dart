import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:movement_analyzer/geolocator_bloc.dart';
import 'package:movement_analyzer/parameter_display.dart';

@immutable
class GeolocationDisplay extends ParameterDisplay<GeolocatorBloc> {
  const GeolocationDisplay({Key? key}) : super(key: key);

  @override
  Text getParameterText(param) {
    if (param is Position) {
      final longitude = param.longitude;
      final latitude = param.latitude;
      return Text('Longitude: $longitude, Latitude: $latitude');
    } else {
      return const Text('');
    }
  }
}
