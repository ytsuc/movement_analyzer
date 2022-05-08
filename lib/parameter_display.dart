import 'package:flutter/material.dart';
import 'package:movement_analyzer/bloc.dart';
import 'package:provider/provider.dart';

abstract class ParameterDisplay<T extends Bloc> extends StatelessWidget {
  const ParameterDisplay({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var geolocatorBloc = Provider.of<T>(context, listen: false);
    return Center(
        child: StreamBuilder(
            stream: geolocatorBloc.stream,
            builder: (context, snapshot) {
              final param = snapshot.data;
              if (param != null) {
                return getParameterText(param);
              } else {
                return const Text('Loading...');
              }
            }));
  }

  Text getParameterText(param);
}
