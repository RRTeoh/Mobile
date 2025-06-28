import 'package:flutter/material.dart';
//import 'package:asgm1/bottom_widgets/bottom_nav_bar.dart';
import 'package:asgm1/bottom_widgets/bottom_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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