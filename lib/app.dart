import 'package:flutter/material.dart';
import 'package:wasteagram/widgets/list_page.dart';

class App extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Wasteagram',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ListPage(),
    );
  }
}
