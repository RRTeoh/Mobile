import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asgm1/screens/Aboutus.dart';
import 'package:asgm1/screens/Helpcenter.dart';
import 'package:asgm1/screens/Notifications.dart';
import 'package:asgm1/screens/PrivacySettings.dart';
import 'package:asgm1/screens/editprofile.dart';
import 'package:asgm1/screens/notification_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SettingsPanel extends StatelessWidget {
  final VoidCallback onClose;

  const SettingsPanel({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        height: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.settings),
                  const SizedBox(width: 10),
                  const Text("Settings",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(),
              _buildItem(
                Icons.account_circle,
                "Manage Account",
                onTap: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    final snapshot = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .get();

                    final data = snapshot.data();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfile(
                          initialFirstName: data?['firstName'] ?? '',
                          initialSecondName: data?['secondName'] ?? '',
                          initialEmail: data?['email'] ?? user.email ?? '',
                        ),
                      ),
                    );
                  }
                },
              ),
              _buildItem(Icons.notifications_outlined,
               "Notifications",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationSettingsPage()),
                    );
                  },                 
               ),
              _buildItem(Icons.lock_outline, "Privacy Settings",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacySettings()),
                    );
                  },              
              ),
             // _buildItem(Icons.language, "Language"),
              _buildItem(Icons.help_outline,
               "Help Center",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Helpcenter()),
                    );
                  },                
              ),
              _buildItem(
                  Icons.info_outline,
                  "About Us",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutBoostify()),
                    );
                  },
                ),
              _buildItem(
                Icons.logout,
                "Logout",
                onTap: () => _signOut(context),
                isLogout: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      // Display the confirmation dialogue box
      bool? shouldLogout = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 22
              )
            ),
            content: const Text(
              'Are you sure you want to log out?',
              style: TextStyle(
                fontSize: 16
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),
              ),
            ],
          );
        },
      );

      if (shouldLogout == true) {
        try {
          await FirebaseAuth.instance.signOut();
          onClose();
          print('User logged out successfully.');
        } catch (signOutError) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to logout: ${signOutError.toString()}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
          print('Logout Error: $signOutError');
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      print('General Error: $e');
    }
  }

  Widget _buildItem(IconData icon, String label, {VoidCallback? onTap, bool isLogout = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(
              icon, 
              size: 22,
              color: isLogout ? Colors.red : null,
            ),
            const SizedBox(width: 12),
            Text(
              label, 
              style: TextStyle(
                fontSize: 16,
                color: isLogout ? Colors.red : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}