// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:intern_task/adrun.dart';
// import 'package:intern_task/dbofflineImage.dart';
// import 'package:intern_task/dbscraoe.dart';
// import 'package:intern_task/login.dart';
// import 'package:intern_task/portfolioPage.dart';
// import 'package:intern_task/scrape.dart';
// import 'package:intern_task/sharesansarScrape.dart';

// void main() {
//   runApp(const MyApp());
//   WidgetsFlutterBinding.ensureInitialized();
//   MobileAds.instance.initialize();
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
//       overlays: [SystemUiOverlay.bottom]);
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // State to manage theme mode
//   bool isDarkMode = false;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: isDarkMode
//           ? ThemeData(
//               brightness: Brightness.dark,
//               useMaterial3: true,
//               colorScheme: const ColorScheme.dark(
//                 primary: Colors.green,
//               ),
//             )
//           : ThemeData(
//               brightness: Brightness.light,
//               useMaterial3: true,
//               colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
//             ),
//       // home: AdScreen()
//       home: ImgWebScraperScreen(),
//       // SSWebScraperScreen(
//       //   onToggleTheme: toggleTheme,
//       //   isDarkMode: isDarkMode,
//       // ),
//     );
//   }

//   // Function to toggle theme
//   void toggleTheme() {
//     setState(() {
//       isDarkMode = !isDarkMode;
//     });
//   }
// }

// lib/main.dart
import 'package:flutter/material.dart';
import 'package:intern_task/notification.dart'; // Ensure this file is correctly named
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  // ✅ Ensure timezone is initialized

  final notificationService = NotificationService();
  await notificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationService =
        NotificationService(); // ✅ Use a single instance

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Daily Notifications')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  notificationService.scheduleDailyNotification(
                    id: 1,
                    title: 'Daily Reminder',
                    body: 'This is your daily notification!',
                    scheduledTime: DateTime.now().add(const Duration(
                        seconds: 60)), //  Fixed 'sec' to 'seconds'
                  );
                },
                child: const Text('Schedule for 1 min from now'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  notificationService
                      .showTestNotification(); // ✅ Use single instance
                },
                child: const Text('Send Test Notification'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
