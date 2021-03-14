import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wasteagram/models/post_dto.dart';
import 'package:wasteagram/widgets/new_entry_page.dart';
import 'package:wasteagram/widgets/post_tile.dart';

const String COLLECTION_NAME = 'posts';

class ListPage extends StatefulWidget {
  static final routeName = 'listPage';
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  ListPage({Key key, this.analytics, this.observer}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future<void> _sendAnalyticsEvent() async {
    await widget.analytics.logEvent(
      name: 'new entry clicked',
      parameters: <String, dynamic>{
        'time': DateTime.now().toString(),
      },
    );
    // setMessage('logEvent succeeded');
  }

  Widget appBarTotal(BuildContext context) {
    return AppBar(
        centerTitle: true,
        title: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(COLLECTION_NAME)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              int total = 0;
              snapshot.data.docs.forEach((item) {
                total = total + item['qty'];
              });
              return Text('Wasteagram - $total');
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTotal(context),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(COLLECTION_NAME)
              .orderBy('date', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return ListView.builder(
              // if db is empty count must be set to 1 to display the Indicator
              itemCount: snapshot.data == null || snapshot.data.size == 0
                  ? 1
                  : snapshot.data.size,

              itemBuilder: (context, index) {
                if (snapshot.hasData && snapshot.data.size != 0) {
                  PostDTO post = PostDTO.fromFirestoreMap(
                      snapshot.data.docs[index].data());

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
          }),
      floatingActionButton: Semantics(
        button: true,
        onTapHint: 'Take a picture',
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            _sendAnalyticsEvent();
            getImage();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewEntryPage(pickedFile.path)));
    } else {
      print('No image selected.');
      setState(() {});
    }
  }
}
