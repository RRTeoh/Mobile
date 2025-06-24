import 'package:flutter/material.dart';
import 'package:asgm1/details/card.dart';
import 'package:asgm1/details/profile.dart';
import 'package:asgm1/details/myreward.dart';
import 'package:asgm1/details/payment.dart';
import 'package:asgm1/screens/editprofile.dart';
import 'package:asgm1/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedIndex = 0;
  bool isSettingsOpen = false;
  String _firstName = 'Loading';
  String _secondName = '';
  @override
  void initState() {
  super.initState();
  _loadUserData(); 
  }

  void _loadUserData() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = snapshot.data();
    if (data != null) {
      setState(() {
        _firstName = data['firstName'] ?? '';
        _secondName = data['secondName'] ?? '';
      });
    }
  }
}
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: isSettingsOpen
            ? null
            : const Text(
                "Membership",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: isSettingsOpen
            ? null
            : IconButton(
                icon: const Icon(Icons.list, color: Colors.black),
                onPressed: () {
                  setState(() {
                    isSettingsOpen = true;
                  });
                },
              ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff8fd4e8), Colors.white],
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Stack(
                      children: [
                        ProfileAvatar(
                          imagePath: 'assets/images/noprofile.png',
                          name: '${_firstName.length > 6 ? _firstName.substring(0, 6) + "***" : _firstName} $_secondName',
                          streak: '145 🔥',
                        ),
                        Positioned(
                          top: 2,
                          left: 40,
                          child: GestureDetector(
                            onTap: () async {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                // Get user data from Firestore
                                final snapshot = await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .get();

                                final data = snapshot.data();

                                // Navigate to EditProfile screen with prefilled data
                                final updatedProfile = await Navigator.push<Map<String, String>>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfile(
                                      initialFirstName: data?['firstName'] ?? user.uid, // fallback to UID
                                      initialSecondName: data?['secondName'] ?? '',
                                      initialEmail: data?['email'] ?? user.email ?? '',
                                    ),
                                  ),
                                );
                                // Optional: update local state if EditProfile returns changes
                                if (updatedProfile != null) {
                                  setState(() {
                                    _firstName = updatedProfile['firstName'] ?? _firstName;
                                    _secondName = updatedProfile['secondName'] ?? _secondName;
                                  });
                                }
                              }
                            },
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.white,
                              child: const Icon(Icons.edit, size: 14, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const MembershipCard(
                  imagePath1: 'assets/images/myprofile/membercard.jpg',
                  imagePath2: 'assets/images/myprofile/barcode2.jpg',
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = 0;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      'My Rewards',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: selectedIndex == 0 ? Colors.black : Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      height: 2,
                                      width: screenWidth * 0.35,
                                      color: selectedIndex == 0 ? Colors.black : Colors.white,
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = 1;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      'Payment',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: selectedIndex == 1 ? Colors.black : Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      height: 2,
                                      width: screenWidth * 0.35,
                                      color: selectedIndex == 1 ? Colors.black : Colors.white,
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: selectedIndex == 0
                              ? const MyRewards()
                              : const MyPayment(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sliding Settings Panel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 0,
            bottom: 0,
            left: isSettingsOpen ? 0 : -screenWidth * 0.75,
            child: Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.75,
                  child: SettingsPanel(
                    onClose: () {
                      setState(() {
                        isSettingsOpen = false;
                      });
                    },
                  ),
                ),
                if (isSettingsOpen)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSettingsOpen = false;
                      });
                    },
                    child: Container(
                      width: screenWidth * 0.25,
                      height: double.infinity,
                      color: Colors.transparent,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
