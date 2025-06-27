import 'package:flutter/material.dart';
import 'package:asgm1/services/notification_service.dart';

class NotificationTestPage extends StatefulWidget {
  const NotificationTestPage({super.key});

  @override
  State<NotificationTestPage> createState() => _NotificationTestPageState();
}

class _NotificationTestPageState extends State<NotificationTestPage> {
  final NotificationService _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Test'),
        backgroundColor: const Color(0xFF8FD4E8),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8FD4E8), Colors.white],
            stops: [0.0, 0.8],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Test Motivational Notifications',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              
              _buildTestCard(
                title: 'Instant Motivation',
                subtitle: 'Send a motivational message right now',
                icon: Icons.flash_on,
                onPressed: () async {
                  await _notificationService.sendInstantMotivationalNotification();
                  _showSnackBar('Instant motivational notification sent! 💪');
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildTestCard(
                title: 'Daily Motivation (8:00 AM)',
                subtitle: 'Schedule daily motivational notifications',
                icon: Icons.wb_sunny,
                onPressed: () async {
                  await _notificationService.scheduleDailyMotivationalNotification(
                    hour: 8,
                    minute: 0,
                  );
                  _showSnackBar('Daily notifications scheduled for 8:00 AM! 🌅');
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildTestCard(
                title: 'Workout Reminder (6:00 PM)',
                subtitle: 'Schedule workout reminders',
                icon: Icons.fitness_center,
                onPressed: () async {
                  await _notificationService.scheduleWorkoutReminder(
                    hour: 18,
                    minute: 0,
                    workoutType: 'cardio',
                  );
                  _showSnackBar('Workout reminders scheduled for 6:00 PM! 🏃‍♀️');
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildTestCard(
                title: 'Weekly Motivation (Monday 9:00 AM)',
                subtitle: 'Schedule weekly motivational notifications',
                icon: Icons.calendar_today,
                onPressed: () async {
                  await _notificationService.scheduleWeeklyMotivationalNotification(
                    weekday: 1, // Monday
                    hour: 9,
                    minute: 0,
                  );
                  _showSnackBar('Weekly notifications scheduled for Monday 9:00 AM! 📅');
                },
              ),
              
              const SizedBox(height: 30),
              
              ElevatedButton(
                onPressed: () async {
                  await _notificationService.cancelAllNotifications();
                  _showSnackBar('All notifications cancelled! 🚫');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancel All Notifications',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              
              const SizedBox(height: 16),
              
              ElevatedButton(
                onPressed: () async {
                  await _notificationService.requestPermissions();
                  _showSnackBar('Notification permissions requested! 🔔');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8FD4E8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Request Permissions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF8FD4E8).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF8FD4E8),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF8FD4E8),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF8FD4E8),
        duration: const Duration(seconds: 2),
      ),
    );
  }
} 