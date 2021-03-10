import 'package:flutter/material.dart';
import 'package:wasteagram/widgets/detail_page.dart';
import 'package:wasteagram/widgets/item_list.dart';
import 'package:wasteagram/widgets/photo_picker.dart';
import 'package:wasteagram/widgets/share_location_screen.dart';

/// used mainly in testing
/// source: https://flutter.dev/docs/cookbook/design/tabs
class TabBarHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.view_list)),
              Tab(icon: Icon(Icons.location_pin)),
              Tab(icon: Icon(Icons.image)),
            ],
          ),
          title: Text('Tabs Demo'),
        ),
        body: TabBarView(
          children: [
            ItemList(),
            ShareLocationScreen(),
            PhotoPicker(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_circle),
          onPressed: () {},
        ),
      ),
    );
  }
}
