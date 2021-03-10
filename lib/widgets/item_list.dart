import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasteagram/models/post_dto.dart';
import 'package:wasteagram/widgets/post_tile.dart';

const String COLLECTION_NAME = 'posts';

class ItemList extends StatefulWidget {
  ItemList({Key key}) : super(key: key);

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(COLLECTION_NAME)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView.builder(
            // if db is empty count must be set to 1 to display the Indicator
            itemCount: snapshot.data == null || snapshot.data.size == 0
                ? 1
                : snapshot.data.size,

            itemBuilder: (context, index) {
              if (snapshot.hasData && snapshot.data.size != 0) {
                PostDTO post =
                    PostDTO.fromMap(snapshot.data.docs[index].data());
                return PostTile(data: post);
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
