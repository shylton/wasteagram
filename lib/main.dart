import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wasteagram/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://5af9e01d3a5d4755ae08a83cfc85f717@o551677.ingest.sentry.io/5675329';
    },
    appRunner: () => runApp(Wasteagram()),
  );
}
