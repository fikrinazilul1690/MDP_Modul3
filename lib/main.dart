import 'package:flutter/material.dart';
import 'package:mod3_kel22/screens/splashscreen.dart';

void main() async {
  runApp(const AnimeApp());
}

class AnimeApp extends StatelessWidget {
  const AnimeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Anime app',
      debugShowCheckedModeBanner: false,
      home: SplashScreenPage(),
    );
  }
}
