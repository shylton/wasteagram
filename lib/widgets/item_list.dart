import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String COLLECTION_NAME = 'blank';
const String TITLE_FIELD = 'desc';

class ItemList extends StatefulWidget {
  ItemList({Key key}) : super(key: key);

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection(COLLECTION_NAME).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView.builder(
            // if db is empty count must be set to 1 to display the Indicator
            itemCount: snapshot.data == null || snapshot.data.size == 0
                ? 1
                : snapshot.data.size,
            itemBuilder: (context, index) {
              if (snapshot.hasData && snapshot.data.size != 0) {
                var post = snapshot.data.docs[index];
                return ListTile(title: Text(post[TITLE_FIELD]));
              } else {
                return Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('indicator goes here'),
                    ],
                  )),
                );
              }
            },
          );
        });
  }
}
