import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ads_mahem/MODELS/DATAMASTER/datamaster.dart';
import 'package:ads_mahem/MODELS/firebase.dart';
import 'package:ads_mahem/VIEWS/login.dart';
import 'package:ads_mahem/VIEWS/playground.dart';
import 'package:ads_mahem/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: "lib/.env");

  runApp(
    MaterialApp(
      home: Login(dm: DataMaster()),
    ),
    // initialRoute: "/",
    // routes: {
    //   // "/": (context) => const PlaygroundView(),
    // },
  );
}
