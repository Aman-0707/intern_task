import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kathmandu'));
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    await notifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    await notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    final ios = notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await ios?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// 🔹 Schedule a Daily Notification with Local Time
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final tz.TZDateTime localScheduledTime =
        tz.TZDateTime.from(scheduledTime, tz.local);

    // Debug: Log scheduling details
    print("Scheduled time (Kathmandu): $localScheduledTime");
    print("Current time (Kathmandu): ${tz.TZDateTime.now(tz.local)}");

    await notifications
        .zonedSchedule(
      id,
      title,
      body,
      localScheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notifications',
          'Daily Notifications',
          channelDescription: 'Daily reminder notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      // matchDateTimeComponents: DateTimeComponents.time,
    )
        .then((_) {
      print(" Notification successfully scheduled");
    }).catchError((error) {
      print(" Error scheduling notification: $error");
    });
  }

  /// 🔹 Fix `_nextInstanceOfTime` to Correctly Handle Local Time Zone
  tz.TZDateTime _nextInstanceOfTime(DateTime scheduledTime) {
    final now =
        tz.TZDateTime.now(tz.local); // Always use tz.local for current time
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    // if (scheduledDate.isBefore(now)) {
    //   scheduledDate = scheduledDate.add(const Duration(days: 1));
    // }

    return scheduledDate;
  }

  /// 🔹 Test Notification (Instant)
  Future<void> showTestNotification() async {
    await notifications.show(
      0,
      'Test Notification',
      'This is a test notification',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_notifications',
          'Test Notifications',
          channelDescription: 'For testing notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
