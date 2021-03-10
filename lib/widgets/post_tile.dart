import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostTile extends StatelessWidget {
  final QueryDocumentSnapshot data;
  final DateFormat dtFrmt = DateFormat('EEEE, MMM. d');

  PostTile({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.chevron_right),
      title: Text(
        dtFrmt.format(DateTime.parse(data['date'].toDate().toString())),
        textAlign: TextAlign.center,
      ),
      trailing: Text(
        data['qty'].toString(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
