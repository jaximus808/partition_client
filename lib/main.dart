import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'pages/homepage/home.dart';
import 'package:flutter/material.dart';

void main() async {
  // await dotenv.load(fileName: ".env");
  runApp(const MaterialApp(
    title: "partition",
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Partition'),
    );
  }
}
