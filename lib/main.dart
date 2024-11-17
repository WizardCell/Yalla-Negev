import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/yalla_negev_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const YallaNegevApp());
}
