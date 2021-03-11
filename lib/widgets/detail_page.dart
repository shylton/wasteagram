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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(data.dateStr),
          Container(
            child: Image.network(data.url),
          ),
          Text(data.qty.toString()),
          Text('(${data.latitude} ${data.longitude})')
        ],
      ),
    );
  }
}
