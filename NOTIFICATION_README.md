# Motivational Notifications System

This Flutter app now includes a comprehensive motivational notification system using Flutter Local Notifications. Users can receive personalized motivational messages to help them stay on track with their fitness goals.

## Features

### 1. Daily Motivational Notifications
- Schedule daily motivational messages at a specific time
- Messages are tailored based on the time of day (morning, afternoon, evening)
- Customizable timing through the settings

### 2. Workout Reminders
- Schedule workout reminders with customizable workout types
- Different motivational messages for different workout types
- Flexible timing options

### 3. Weekly Motivational Notifications
- Weekly inspiration messages on a specific day of the week
- Perfect for weekend motivation or weekly goal setting

### 4. Instant Motivation
- Send motivational messages immediately
- Great for when users need a quick boost of motivation

## Implementation Details

### Dependencies Added
```yaml
dependencies:
  flutter_local_notifications: ^17.2.2
  timezone: ^0.9.4
```

### Files Created/Modified

1. **`lib/services/notification_service.dart`**
   - Main notification service class
   - Handles all notification scheduling and sending
   - Contains motivational message collections
   - Manages notification permissions

2. **`lib/screens/notification_settings.dart`**
   - User interface for configuring notifications
   - Settings persistence using SharedPreferences
   - Time picker integration
   - Workout type and weekday selectors

3. **`lib/screens/notification_test.dart`**
   - Test page for demonstrating notification functionality
   - Easy testing of all notification types

4. **`lib/main.dart`**
   - Added notification service initialization
   - Permission requests on app startup

5. **`lib/screens/home_page.dart`**
   - Added notification settings button in app bar
   - Added "Get Motivated" button for instant notifications
   - Added test button for easy access to test page

6. **`lib/settings.dart`**
   - Updated notifications menu item to link to new settings page

7. **`android/app/src/main/AndroidManifest.xml`**
   - Added necessary Android permissions for notifications

## Motivational Messages

The system includes different message categories:

### Morning Messages (6 AM - 12 PM)
- "Good morning! 💪 Time to crush your fitness goals today!"
- "Rise and shine! 🌅 Your body is ready for an amazing workout!"
- "Morning motivation: Every rep counts towards your goals! 💪"

### Afternoon Messages (12 PM - 6 PM)
- "Afternoon energy boost! ⚡ Time for a quick workout!"
- "Midday motivation: You're stronger than you think! 💪"
- "Keep pushing! Your progress is inspiring! 🌟"

### Evening Messages (6 PM - 10 PM)
- "Evening workout time! 🌙 Let's finish the day strong!"
- "Don't let the day end without moving your body! 💪"
- "Evening motivation: Consistency beats perfection! 🔥"

### General Messages
- "Remember why you started! 💪"
- "Your body can do amazing things! Believe in yourself! 🌟"
- "Every workout makes you stronger! 💯"

## How to Use

### For Users:
1. **Access Settings**: Tap the notification icon in the app bar or go to Settings → Notifications
2. **Configure Notifications**: 
   - Enable/disable different notification types
   - Set preferred times for each notification type
   - Choose workout types and weekdays
3. **Get Instant Motivation**: Use the "Get Motivated" button on the home page
4. **Test Notifications**: Use the "Test" button to try different notification types

### For Developers:
1. **Initialize Service**: The service is automatically initialized in `main.dart`
2. **Send Notifications**: Use the `NotificationService` singleton
3. **Customize Messages**: Modify the message arrays in `notification_service.dart`
4. **Add New Types**: Extend the service with new notification methods

## Example Usage

```dart
// Get the notification service instance
final notificationService = NotificationService();

// Send instant motivational notification
await notificationService.sendInstantMotivationalNotification();

// Schedule daily notifications at 8:00 AM
await notificationService.scheduleDailyMotivationalNotification(
  hour: 8,
  minute: 0,
);

// Schedule workout reminders at 6:00 PM
await notificationService.scheduleWorkoutReminder(
  hour: 18,
  minute: 0,
  workoutType: 'cardio',
);

// Schedule weekly notifications on Monday at 9:00 AM
await notificationService.scheduleWeeklyMotivationalNotification(
  weekday: 1, // Monday
  hour: 9,
  minute: 0,
);

// Cancel all notifications
await notificationService.cancelAllNotifications();
```

## Permissions

The app requests the following permissions:
- **Android**: `RECEIVE_BOOT_COMPLETED`, `VIBRATE`, `WAKE_LOCK`, `SCHEDULE_EXACT_ALARM`
- **iOS**: Alert, Badge, and Sound permissions

## Testing

1. Use the "Test" button on the home page to access the test interface
2. Try different notification types to ensure they work correctly
3. Test on both Android and iOS devices
4. Verify that notifications persist after app restart

## Future Enhancements

- Add more personalized messages based on user preferences
- Integrate with fitness tracking data for contextual messages
- Add notification sound customization
- Implement notification history
- Add achievement-based notifications
- Support for custom motivational quotes from users

## Troubleshooting

- **Notifications not showing**: Check device notification permissions
- **Scheduled notifications not working**: Verify timezone settings
- **App crashes on notification**: Ensure proper initialization in main.dart
- **Android-specific issues**: Check Android manifest permissions 