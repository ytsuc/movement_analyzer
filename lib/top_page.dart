import 'package:flutter/material.dart';
import 'package:movement_analyzer/accel_state_display.dart';
import 'package:movement_analyzer/accelerometer_bloc.dart';
import 'package:movement_analyzer/accelerometer_display.dart';
import 'package:movement_analyzer/current_position_map.dart';
import 'package:movement_analyzer/geolocation_display.dart';
import 'package:movement_analyzer/geolocator_bloc.dart';
import 'package:provider/provider.dart';

class Blocs {
  AccelerometerBloc accelerometerBloc;
  GeolocatorBloc geolocatorBloc;
  Blocs(this.accelerometerBloc, this.geolocatorBloc);
}

@immutable
class TopPage extends StatelessWidget {
  const TopPage({Key? key}) : super(key: key);

  Future<Blocs> _createAccelBloc() async {
    return Blocs(
        await AccelerometerBloc.create(), await GeolocatorBloc.create());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _createAccelBloc(),
        builder: (context, AsyncSnapshot<Blocs> snapshot) {
          final blocs = snapshot.data;
          if (snapshot.connectionState == ConnectionState.done &&
              blocs != null) {
            return MultiProvider(
                providers: [
                  Provider<GeolocatorBloc>(
                    create: (context) => blocs.geolocatorBloc,
                    dispose: (_, bloc) => bloc.dispose(),
                  ),
                  Provider<AccelerometerBloc>(
                    create: (context) => blocs.accelerometerBloc,
                    dispose: (_, bloc) => bloc.dispose(),
                  ),
                ],
                child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                      appBar: AppBar(
                        title: const Text('Movement Analyzer'),
                        bottom: const TabBar(tabs: [
                          Tab(icon: Icon(Icons.text_snippet), text: '数値'),
                          Tab(
                            icon: Icon(Icons.map),
                            text: '地図',
                          )
                        ]),
                      ),
                      body: TabBarView(
                        children: <Widget>[
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                GeolocationDisplay(),
                                AccelerometerDisplay(),
                                AccelStateDisplay()
                              ]),
                          const CurrentPositionMap()
                        ],
                      )),
                ));
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}