import 'package:flutter/material.dart';
import 'package:movement_analyzer/bloc/login_user.dart';
import 'package:movement_analyzer/database/database_manager.dart';
import 'package:movement_analyzer/wedget/login_page.dart';
import 'package:provider/provider.dart';

class TopPage extends StatelessWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseManager.create(),
        builder: ((context, AsyncSnapshot<DatabaseManager> snapshot) {
          final databaseManager = snapshot.data;
          if (snapshot.connectionState == ConnectionState.done &&
              databaseManager != null) {
            return MultiProvider(
              providers: [
                Provider<DatabaseManager>(
                  create: (context) => databaseManager,
                ),
                Provider<LoginUser>(
                  create: (context) => LoginUser(),
                )
              ],
              child: const LoginPage(),
            );
          } else {
            return const Text('Now Loading...');
          }
        }));
  }
}
