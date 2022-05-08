import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:movement_analyzer/geolocator_bloc.dart';
import 'package:provider/provider.dart';

@immutable
class CurrentPositionMap extends StatelessWidget {
  const CurrentPositionMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var geolocatorBloc = Provider.of<GeolocatorBloc>(context, listen: true);
    return Center(
        child: StreamBuilder(
            stream: geolocatorBloc.stream,
            builder: (context, AsyncSnapshot<Position> snapshot) {
              final position = snapshot.data;
              if (position is Position) {
                final target = LatLng(position.latitude, position.longitude);
                final camera = CameraPosition(target: target, zoom: 15);
                return GoogleMap(
                    initialCameraPosition: camera,
                    circles: <Circle>{
                      Circle(
                          circleId: const CircleId('hofe'),
                          center: target,
                          radius: 10,
                          fillColor: const Color.fromARGB(188, 172, 12, 12)),
                    });
              } else {
                return const Text('Loading...');
              }
            }));
  }
}
