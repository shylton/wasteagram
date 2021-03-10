import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wasteagram/models/post_dto.dart';

class PostTile extends StatelessWidget {
  final PostDTO data;

  PostTile({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.chevron_right),
      title: Text(
        data.dateStr,
        textAlign: TextAlign.center,
      ),
      trailing: Text(
        data.qty.toString(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
