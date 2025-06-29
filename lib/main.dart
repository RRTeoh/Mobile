import 'package:flutter/material.dart';
//import 'package:asgm1/bottom_widgets/bottom_nav_bar.dart';
import 'package:asgm1/bottom_widgets/bottom_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:asgm1/screens/login_page.dart';
import 'package:asgm1/screens/IntroVideoPage.dart';
import 'package:asgm1/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.requestPermissions();
  
  // Setup FCM for external notifications
  await _setupFCM();
  
  runApp(MyApp());
}

Future<void> _setupFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  
  // Request permission
  await messaging.requestPermission();
  
  // Save FCM token
  await _saveFcmToken();
  
  // Listen for FCM messages when app is in foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("DEBUG: FCM Message received in foreground");
    
    if (message.data.isNotEmpty) {
      String senderName = message.data['senderName'] ?? 'Someone';
      String action = message.data['action'] ?? '';
      String type = message.data['type'] ?? '';
      
      if (type == 'chat') {
        NotificationService().sendChatNotification(
          title: message.notification?.title ?? 'New Message',
          body: message.notification?.body ?? '',
        );
      } else {
        NotificationService().sendFeedNotification(
          title: message.notification?.title ?? 'New Activity',
          body: message.notification?.body ?? '',
        );
      }
    }
  });
  
  // Handle FCM messages when app is opened from notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("DEBUG: App opened from FCM notification");
    // Handle navigation based on notification type
    if (message.data['type'] == 'chat') {
      // Navigate to chat
    } else {
      // Navigate to feed
    }
  });
}

Future<void> _saveFcmToken() async {
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'fcmToken': token,
        });
        print('FCM token saved: $token');
      }
    }
  } catch (e) {
    print('Error saving FCM token: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashVideoPage(),
    );
  }
}

// Authentication Wrapper - Display different pages based on login status
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          User user = snapshot.data!;
          
          // Check if user is verified and has Firestore data
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get(),
            builder: (context, firestoreSnapshot) {
              if (firestoreSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              // If user is not verified or doesn't exist in Firestore, show login
              if (!user.emailVerified || !firestoreSnapshot.hasData || !firestoreSnapshot.data!.exists) {
                // Sign out the user if they're not properly verified
                FirebaseAuth.instance.signOut();
                return LoginPage();
              }
              
              // User is verified and has data, show main app
              return BottomApp();
            },
          );
        } else {
          // User is not logged in, show login page
          return LoginPage();
        }
      },
    );
  }
}