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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // State to manage theme mode
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: isDarkMode
          ? ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
              colorScheme: const ColorScheme.dark(
                primary: Colors.green,
              ),
            )
          : ThemeData(
              brightness: Brightness.light,
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            ),
      home: SSWebScraperScreen(
        onToggleTheme: toggleTheme,
        isDarkMode: isDarkMode,
      ),
    );
  }

  // Function to toggle theme
  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }
}
