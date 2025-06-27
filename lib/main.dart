import 'package:flutter/material.dart';
//import 'package:asgm1/bottom_widgets/bottom_nav_bar.dart';
import 'package:asgm1/bottom_widgets/bottom_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  
  runApp(MyApp());
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
        // The user is logged in and the main application is displayed
        if (snapshot.hasData) {
          return BottomApp();
        }
        // User is not logged in, show login page
        else {
          return LoginPage();
        }
      },
    );
  }
}