import 'package:flutter/material.dart';
import 'package:spider/home/home_page.dart';
import 'package:spider/logger/app_logger.dart';

void main() {
  AppLogger.configureLogging();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
