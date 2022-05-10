import 'package:flutter/material.dart';
import 'package:movement_analyzer/bloc/login_user.dart';
import 'package:movement_analyzer/database/database_manager.dart';
import 'package:provider/provider.dart';

@immutable
class MovementList extends StatelessWidget {
  const MovementList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseManager>(context);

    return FutureBuilder(
        future: database.getMovements(Provider.of<LoginUser>(context).id),
        builder: (context, AsyncSnapshot snaphsot) {
          if (snaphsot.connectionState == ConnectionState.done &&
              snaphsot.data != null) {
            final movements = snaphsot.data;
            return SizedBox(
                width: double.infinity,
                child: DataTable(columns: [
                  for (String label in ["経度", "緯度", "加速度評価値", "記録時間"])
                    DataColumn(label: Text(label))
                ], rows: [
                  for (var record in movements)
                    DataRow(cells: [
                      for (String content in [
                        record['latitude'].toString(),
                        record['longitude'].toString(),
                        record['acceleration'].toString(),
                        record['recorded_at'].toString(),
                      ])
                        DataCell(Text(content))
                    ])
                ]));
          } else {
            return const Text("Loading...");
          }
        });
  }
}
