import 'package:flutter/material.dart';
import 'package:movement_analyzer/wedget/login_page.dart';
import 'package:movement_analyzer/wedget/infomation_page.dart';
import 'package:movement_analyzer/wedget/top_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TopPage()); //const TopPage());
  }
}
