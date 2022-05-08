import 'package:flutter/material.dart';
import 'package:movement_analyzer/accelerometer_bloc.dart';
import 'package:movement_analyzer/geolocator_bloc.dart';
import 'package:provider/provider.dart';

class TickIntervalSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final geolocatorBloc = Provider.of<GeolocatorBloc>(context);
    final accelerometerBloc = Provider.of<AccelerometerBloc>(context);
    return Slider(value: 5, onChanged: (double value) {});
  }
}
