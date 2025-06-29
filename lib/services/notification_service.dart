import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  // Motivational messages for different times of day
  final List<String> _morningMessages = [
    "Good morning! 💪 Time to crush your fitness goals today!",
    "Rise and shine! 🌅 Your body is ready for an amazing workout!",
    "Morning motivation: Every rep counts towards your goals! 💪",
    "Start your day strong! Your future self will thank you! 🏃‍♀️",
    "Good morning! Let's make today count! 💯",
  ];

  final List<String> _afternoonMessages = [
    "Afternoon energy boost! ⚡ Time for a quick workout!",
    "Midday motivation: You're stronger than you think! 💪",
    "Keep pushing! Your progress is inspiring! 🌟",
    "Afternoon reminder: Your health is an investment! 💎",
    "Stay focused! Every step brings you closer to your goals! 🎯",
  ];

  final List<String> _eveningMessages = [
    "Evening workout time! 🌙 Let's finish the day strong!",
    "Don't let the day end without moving your body! 💪",
    "Evening motivation: Consistency beats perfection! 🔥",
    "Time for your evening routine! Your body deserves it! ❤️",
    "End your day with energy! You've got this! 💪",
  ];

  final List<String> _generalMessages = [
    "Remember why you started! 💪",
    "Your body can do amazing things! Believe in yourself! 🌟",
    "Every workout makes you stronger! 💯",
    "You're building a better version of yourself! 🔥",
    "Stay consistent, stay motivated! 🎯",
    "Your future self is watching! Make them proud! 💪",
    "Small progress is still progress! Keep going! 🌱",
    "You have the power to change your life! ⚡",
    "Don't give up on yourself! You're worth it! ❤️",
    "Today's effort is tomorrow's strength! 💪",
  ];

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings = 
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  Future<void> requestPermissions() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
    
    final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  String _getRandomMessage(List<String> messages) {
    final random = DateTime.now().millisecondsSinceEpoch % messages.length;
    return messages[random];
  }

  String _getMessageForTime() {
    final hour = DateTime.now().hour;
    
    if (hour >= 6 && hour < 12) {
      return _getRandomMessage(_morningMessages);
    } else if (hour >= 12 && hour < 18) {
      return _getRandomMessage(_afternoonMessages);
    } else if (hour >= 18 && hour < 22) {
      return _getRandomMessage(_eveningMessages);
    } else {
      return _getRandomMessage(_generalMessages);
    }
  }

  Future<void> scheduleDailyMotivationalNotification({
    required int hour,
    required int minute,
    String? customMessage,
  }) async {
    final message = customMessage ?? _getMessageForTime();
    
    await _notifications.zonedSchedule(
      0, // Unique ID for daily notification
      'Fitness Motivation 💪',
      message,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'motivational_channel',
          'Motivational Notifications',
          channelDescription: 'Daily motivational fitness notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF8FD4E8),
          enableVibration: true,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleWorkoutReminder({
    required int hour,
    required int minute,
    String workoutType = 'workout',
  }) async {
    final messages = [
      "Time for your $workoutType! 💪",
      "Your $workoutType is waiting! 🔥",
      "Ready to crush your $workoutType? 💯",
      "Let's get moving! $workoutType time! 🏃‍♀️",
      "Your body is ready for $workoutType! ⚡",
    ];
    
    final message = _getRandomMessage(messages);
    
    await _notifications.zonedSchedule(
      1, // Unique ID for workout reminder
      'Workout Reminder 🏋️',
      message,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'workout_channel',
          'Workout Reminders',
          channelDescription: 'Scheduled workout reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF8FD4E8),
          enableVibration: true,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> sendInstantMotivationalNotification() async {
    final message = _getMessageForTime();
    
    await _notifications.show(
      2, // Unique ID for instant notification
      'Fitness Motivation 💪',
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_channel',
          'Instant Motivational',
          channelDescription: 'Instant motivational notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF8FD4E8),
          enableVibration: true,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  Future<void> scheduleWeeklyMotivationalNotification({
    required int weekday, // 1 = Monday, 7 = Sunday
    required int hour,
    required int minute,
  }) async {
    final message = _getRandomMessage(_generalMessages);
    
    await _notifications.zonedSchedule(
      3, // Unique ID for weekly notification
      'Weekly Motivation 🌟',
      message,
      _nextInstanceOfWeekday(weekday, hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly_channel',
          'Weekly Motivational',
          channelDescription: 'Weekly motivational notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF8FD4E8),
          enableVibration: true,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfWeekday(int weekday, int hour, int minute) {
    tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local);
    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    scheduledDate = tz.TZDateTime(
      tz.local,
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      hour,
      minute,
    );
    
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }
    
    return scheduledDate;
  }

  Future<void> sendCustomInstantNotification({required String title, required String body}) async {
    await _notifications.show(
      99, // Unique ID for custom notification
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'custom_channel',
          'Custom Notifications',
          channelDescription: 'Custom instant notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF8FD4E8),
          enableVibration: true,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  Future<void> sendChatNotification({required String title, required String body}) async {
    await _notifications.show(
      100, // Unique ID for chat notification
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'chat_channel',
          'Chat Notifications',
          channelDescription: 'Chat message notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF8FD4E8),
          enableVibration: true,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  Future<void> sendFeedNotification({required String title, required String body}) async {
    await _notifications.show(
      101, // Unique ID for feed notification
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'feed_channel',
          'Feed Notifications',
          channelDescription: 'Feed activity notifications (likes, comments)',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF8FD4E8),
          enableVibration: true,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
} 