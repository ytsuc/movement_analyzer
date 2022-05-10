import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:movement_analyzer/wedget/geolocation_display.dart';
import 'package:movement_analyzer/bloc/geolocator_bloc.dart';

@immutable
class TimerGeolocationDisplay extends GeolocationDisplay {
  const TimerGeolocationDisplay({Key? key}) : super(key: key);

  @override
  Widget getParameterText(param) {
    if (param is Position) {
      final now = DateTime.now().toString();
      return Column(children: [
        super.getParameterText(param),
        Text(now),
      ]);
    } else {
      return const Text('');
    }
  }

  @override
  Stream getStream(GeolocatorBloc bloc) {
    return bloc.timerStream;
  }
}
