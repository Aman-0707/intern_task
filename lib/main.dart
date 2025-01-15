import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intern_task/login.dart';
import 'package:intern_task/portfolioPage.dart';
import 'package:intern_task/scrape.dart';
import 'package:intern_task/sharesansarScrape.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.bottom]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: SSWebScraperScreen(),
    );
  }
}
