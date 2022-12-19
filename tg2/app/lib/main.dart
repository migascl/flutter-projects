import 'package:flutter/material.dart';
import 'package:tg2/pages/start_page.dart';

void main() {
  runApp(const TG2());
}

class TG2 extends StatelessWidget {
  const TG2({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TG2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartPage(apiUri: "http://10.0.2.2:3000"),
    );
  }
}
