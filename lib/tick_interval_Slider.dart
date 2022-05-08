import 'package:flutter/material.dart';
import 'package:movement_analyzer/geolocator_bloc.dart';
import 'package:provider/provider.dart';

class TimerIntervalSlider extends StatefulWidget {
  const TimerIntervalSlider({Key? key}) : super(key: key);

  @override
  State<TimerIntervalSlider> createState() => _TimerIntervalSliderState();
}

class _TimerIntervalSliderState extends State<TimerIntervalSlider> {
  double _currentSliderValue = 3;
  @override
  Widget build(BuildContext context) {
    final geolocatorBloc = Provider.of<GeolocatorBloc>(context);
    return Slider(
        value: _currentSliderValue,
        divisions: 30,
        max: 30,
        min: 1,
        label: _currentSliderValue.round().toString(),
        onChanged: (double value) {
          setState(() {
            _currentSliderValue = value;
          });
          geolocatorBloc.changeTimerInterval(value.toInt());
        });
  }
}
