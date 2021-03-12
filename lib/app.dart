import 'package:flutter/material.dart';
import 'package:wasteagram/widgets/detail_page.dart';
import 'package:wasteagram/widgets/list_page.dart';
import 'package:wasteagram/widgets/new_entry_page.dart';
import 'package:wasteagram/widgets/photo_picker.dart';
import 'package:wasteagram/widgets/tab_bar_home.dart';

class App extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    // final routes = {
    //   DetailPage.routeName: (context) => DetailPage(),
    //   ListPage.routeName: (context) => ListPage(),
    //   PhotoPicker.routeName: (context) => PhotoPicker(),
    //   NewEntryPage.routeName: (context) => NewEntryPage(null),
    // };

    return MaterialApp(
      title: 'Wasteagram',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // routes: routes,
      // initialRoute: ListPage.routeName,
      home: ListPage(),
    );
  }
}
