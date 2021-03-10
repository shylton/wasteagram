import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(
          'https://firebasestorage.googleapis.com/v0/b/wasteagram-ec660.appspot.com/o/pexels-arthouse-studio-4640864.jpg?alt=media&token=d9423a08-84ef-439d-97f8-d12e35f12171'),
    );
  }
}
