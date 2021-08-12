//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:letsworkwearableapp/src/app.dart';
import 'package:firebase_core/firebase_core.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await Firebase.initializeApp();
  runApp(App());
}
