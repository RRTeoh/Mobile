import 'package:flutter/material.dart';
import 'package:asgm1/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final NotificationService _notificationService = NotificationService();
  
  bool _dailyNotificationsEnabled = false;
  bool _workoutRemindersEnabled = false;
  bool _weeklyNotificationsEnabled = false;
  bool _instantNotificationsEnabled = false;
  
  TimeOfDay _dailyNotificationTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _workoutReminderTime = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay _weeklyNotificationTime = const TimeOfDay(hour: 9, minute: 0);
  
  int _selectedWeekday = 1; // Monday
  String _selectedWorkoutType = 'workout';
  
  final List<String> _weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
    'Friday', 'Saturday', 'Sunday'
  ];
  
  final List<String> _workoutTypes = [
    'workout', 'cardio', 'strength training', 'yoga', 
    'pilates', 'HIIT', 'running', 'cycling'
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dailyNotificationsEnabled = prefs.getBool('daily_notifications') ?? false;
      _workoutRemindersEnabled = prefs.getBool('workout_reminders') ?? false;
      _weeklyNotificationsEnabled = prefs.getBool('weekly_notifications') ?? false;
      _instantNotificationsEnabled = prefs.getBool('instant_notifications') ?? false;
      
      final dailyHour = prefs.getInt('daily_hour') ?? 8;
      final dailyMinute = prefs.getInt('daily_minute') ?? 0;
      _dailyNotificationTime = TimeOfDay(hour: dailyHour, minute: dailyMinute);
      
      final workoutHour = prefs.getInt('workout_hour') ?? 18;
      final workoutMinute = prefs.getInt('workout_minute') ?? 0;
      _workoutReminderTime = TimeOfDay(hour: workoutHour, minute: workoutMinute);
      
      final weeklyHour = prefs.getInt('weekly_hour') ?? 9;
      final weeklyMinute = prefs.getInt('weekly_minute') ?? 0;
      _weeklyNotificationTime = TimeOfDay(hour: weeklyHour, minute: weeklyMinute);
      
      _selectedWeekday = prefs.getInt('selected_weekday') ?? 1;
      _selectedWorkoutType = prefs.getString('selected_workout_type') ?? 'workout';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_notifications', _dailyNotificationsEnabled);
    await prefs.setBool('workout_reminders', _workoutRemindersEnabled);
    await prefs.setBool('weekly_notifications', _weeklyNotificationsEnabled);
    await prefs.setBool('instant_notifications', _instantNotificationsEnabled);
    
    await prefs.setInt('daily_hour', _dailyNotificationTime.hour);
    await prefs.setInt('daily_minute', _dailyNotificationTime.minute);
    await prefs.setInt('workout_hour', _workoutReminderTime.hour);
    await prefs.setInt('workout_minute', _workoutReminderTime.minute);
    await prefs.setInt('weekly_hour', _weeklyNotificationTime.hour);
    await prefs.setInt('weekly_minute', _weeklyNotificationTime.minute);
    
    await prefs.setInt('selected_weekday', _selectedWeekday);
    await prefs.setString('selected_workout_type', _selectedWorkoutType);
  }

  Future<void> _updateDailyNotifications() async {
    if (_dailyNotificationsEnabled) {
      await _notificationService.scheduleDailyMotivationalNotification(
        hour: _dailyNotificationTime.hour,
        minute: _dailyNotificationTime.minute,
      );
    } else {
      await _notificationService.cancelNotification(0);
    }
    await _saveSettings();
  }

  Future<void> _updateWorkoutReminders() async {
    if (_workoutRemindersEnabled) {
      await _notificationService.scheduleWorkoutReminder(
        hour: _workoutReminderTime.hour,
        minute: _workoutReminderTime.minute,
        workoutType: _selectedWorkoutType,
      );
    } else {
      await _notificationService.cancelNotification(1);
    }
    await _saveSettings();
  }

  Future<void> _updateWeeklyNotifications() async {
    if (_weeklyNotificationsEnabled) {
      await _notificationService.scheduleWeeklyMotivationalNotification(
        weekday: _selectedWeekday,
        hour: _weeklyNotificationTime.hour,
        minute: _weeklyNotificationTime.minute,
      );
    } else {
      await _notificationService.cancelNotification(3);
    }
    await _saveSettings();
  }

  Future<void> _selectTime(BuildContext context, bool isDaily, bool isWorkout) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isDaily ? _dailyNotificationTime : 
                  isWorkout ? _workoutReminderTime : _weeklyNotificationTime,
    );
    
    if (picked != null) {
      setState(() {
        if (isDaily) {
          _dailyNotificationTime = picked;
        } else if (isWorkout) {
          _workoutReminderTime = picked;
        } else {
          _weeklyNotificationTime = picked;
        }
      });
      
      if (isDaily && _dailyNotificationsEnabled) {
        await _updateDailyNotifications();
      } else if (isWorkout && _workoutRemindersEnabled) {
        await _updateWorkoutReminders();
      } else if (!isDaily && !isWorkout && _weeklyNotificationsEnabled) {
        await _updateWeeklyNotifications();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings', 
        style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF8FD4E8),
        foregroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionCard(
              title: 'Daily Motivational Notifications',
              subtitle: 'Get inspired every day at ${_dailyNotificationTime.format(context)}',
              icon: Icons.wb_sunny,
              isEnabled: _dailyNotificationsEnabled,
              onChanged: (value) async {
                setState(() {
                  _dailyNotificationsEnabled = value;
                });
                await _updateDailyNotifications();
              },
              onTap: () => _selectTime(context, true, false),
            ),
            
            const SizedBox(height: 16),
            
            _buildSectionCard(
              title: 'Workout Reminders',
              subtitle: 'Reminder for $_selectedWorkoutType at ${_workoutReminderTime.format(context)}',
              icon: Icons.fitness_center,
              isEnabled: _workoutRemindersEnabled,
              onChanged: (value) async {
                setState(() {
                  _workoutRemindersEnabled = value;
                });
                await _updateWorkoutReminders();
              },
              onTap: () => _selectTime(context, false, true),
              additionalWidget: _buildWorkoutTypeSelector(),
            ),
            
            const SizedBox(height: 16),
            
            _buildSectionCard(
              title: 'Weekly Motivational Notifications',
              subtitle: 'Weekly inspiration on ${_weekdays[_selectedWeekday - 1]} at ${_weeklyNotificationTime.format(context)}',
              icon: Icons.calendar_today,
              isEnabled: _weeklyNotificationsEnabled,
              onChanged: (value) async {
                setState(() {
                  _weeklyNotificationsEnabled = value;
                });
                await _updateWeeklyNotifications();
              },
              onTap: () => _selectTime(context, false, false),
              additionalWidget: _buildWeekdaySelector(),
            ),
            
            const SizedBox(height: 16),
            
            _buildSectionCard(
              title: 'Instant Motivation',
              subtitle: 'Get a motivational message right now',
              icon: Icons.flash_on,
              isEnabled: _instantNotificationsEnabled,
              onChanged: (value) async {
                setState(() {
                  _instantNotificationsEnabled = value;
                });
                if (value) {
                  await _notificationService.sendInstantMotivationalNotification();
                }
                await _saveSettings();
              },
              onTap: null,
            ),
            
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: () async {
                await _notificationService.requestPermissions();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification permissions requested!'),
                    backgroundColor: Color(0xFF8FD4E8),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 129, 192, 209),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Request Notification Permissions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: () async {
                await _notificationService.cancelAllNotifications();
                setState(() {
                  _dailyNotificationsEnabled = false;
                  _workoutRemindersEnabled = false;
                  _weeklyNotificationsEnabled = false;
                  _instantNotificationsEnabled = false;
                });
                await _saveSettings();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All notifications cancelled!'),
                    backgroundColor: Colors.red,
                  ),
                );
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
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isEnabled,
    required ValueChanged<bool> onChanged,
    VoidCallback? onTap,
    Widget? additionalWidget,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF8FD4E8), size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
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
                Switch(
                  value: isEnabled,
                  onChanged: onChanged,
                  activeColor: const Color(0xFF8FD4E8),
                ),
              ],
            ),
            if (additionalWidget != null) ...[
              const SizedBox(height: 12),
              additionalWidget,
            ],
            if (onTap != null && isEnabled) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8FD4E8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Color(0xFF8FD4E8)),
                      const SizedBox(width: 8),
                      Text(
                        'Change Time',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 122, 184, 201),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Workout Type:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedWorkoutType,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: _workoutTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type.replaceAll('_', ' ').toUpperCase()),
            );
          }).toList(),
          onChanged: (value) async {
            if (value != null) {
              setState(() {
                _selectedWorkoutType = value;
              });
              if (_workoutRemindersEnabled) {
                await _updateWorkoutReminders();
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildWeekdaySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Day of Week:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: _selectedWeekday,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: List.generate(7, (index) {
            return DropdownMenuItem(
              value: index + 1,
              child: Text(_weekdays[index]),
            );
          }),
          onChanged: (value) async {
            if (value != null) {
              setState(() {
                _selectedWeekday = value;
              });
              if (_weeklyNotificationsEnabled) {
                await _updateWeeklyNotifications();
              }
            }
          },
        ),
      ],
    );
  }
} 