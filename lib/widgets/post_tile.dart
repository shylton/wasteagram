import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:wasteagram/models/post_dto.dart';
import 'package:wasteagram/widgets/detail_page.dart';

class PostTile extends StatelessWidget {
  final PostDTO data;

  PostTile({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics.fromProperties(
      properties: props(data),
      child: ListTile(
        leading: Icon(Icons.chevron_right),
        title: Text(
          data.dateStr,
          textAlign: TextAlign.center,
        ),
        trailing: Text(
          data.qty.toString(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DetailPage(data: data)));
        },
      ),
    );
  }

  SemanticsProperties props(PostDTO data) {
    return SemanticsProperties(
        label: '${data.qty.toString()} items on ${data.dateStr}',
        hint: 'Click for details');
  }
}
