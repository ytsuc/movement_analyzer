import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:movement_analyzer/accelerometer_bloc.dart';
import 'package:movement_analyzer/accelerometer_display.dart';
import 'package:movement_analyzer/geolocation_display.dart';
import 'package:movement_analyzer/geolocator_bloc.dart';
import 'package:provider/provider.dart';

@immutable
class TopPage extends StatelessWidget {
  const TopPage({Key? key}) : super(key: key);

  Future<AccelerometerBloc> _createAccelBloc() async {
    return await AccelerometerBloc.create();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _createAccelBloc(),
        builder: (context, AsyncSnapshot<AccelerometerBloc> snapshot) {
          final accelBloc = snapshot.data;
          if (snapshot.connectionState == ConnectionState.done &&
              accelBloc != null) {
            return MultiProvider(
                providers: [
                  Provider<GeolocatorBloc>(
                    create: (context) => GeolocatorBloc(),
                    dispose: (_, bloc) => bloc.dispose(),
                  ),
                  Provider<AccelerometerBloc>(
                    create: (context) => accelBloc,
                    dispose: (_, bloc) => bloc.dispose(),
                  ),
                ],
                child: Stack(
                  children: <Widget>[
                    Scaffold(
                        appBar: AppBar(
                          title: const Text('MovementAnalyzer'),
                        ),
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const <Widget>[
                            GeolocationDisplay(),
                            AccelerometerDisplay()
                          ],
                        ))
                  ],
                ));
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
