import 'package:flutter/material.dart';
import 'package:wasteagram/models/post_dto.dart';

class DetailPage extends StatelessWidget {
  static final routeName = 'details';
  final PostDTO data;

  DetailPage({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wasteagram'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data.dateStr, style: Theme.of(context).textTheme.headline4),
            SizedBox(height: 18.0),
            Container(
              decoration: BoxDecoration(border: Border.all(width: 2.0)),
              child: Image.network(data.url),
            ),
            SizedBox(height: 18.0),
            Text('Items: ${data.qty.toString()}',
                style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 18.0),
            Text('(${data.latitude}, ${data.longitude})',
                style: Theme.of(context).textTheme.headline6)
          ],
        ),
      ),
    );
  }
}
