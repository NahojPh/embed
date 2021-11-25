import 'package:flutter/material.dart';
 import 'package:flutter/services.dart';

import 'package:bilapp/views/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Home(),
    title: "Car Controller",
    theme: ThemeData(
      brightness: Brightness.light,
      backgroundColor: Colors.blueGrey,
      primaryColorLight: Colors.blueGrey,
      primaryColorDark: const Color(0xFF263238),
      secondaryHeaderColor: const Color(0xFF388E3C),
      //secondaryHeaderColorDark: const Color(0xFF1B5E20),
      


      fontFamily: "Outfit",
    ),
  ));
}
