import 'package:flutter/material.dart';
import 'package:asgm1/details/card.dart';
import 'package:asgm1/details/profile.dart';
import 'package:asgm1/details/myreward.dart';
import 'package:asgm1/details/payment.dart';
import 'package:asgm1/settings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedIndex = 0;
  bool isSettingsOpen = false;

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
                  fontSize: 20,
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.lightBlue.shade100, Colors.white],
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: ProfileAvatar(
                      imagePath: 'assets/images/Profile.png',
                      name: 'Jackson Wang',
                      streak: '145 🔥',
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
                                        color: selectedIndex == 0
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      height: 2,
                                      width: screenWidth * 0.35,
                                      color: selectedIndex == 0
                                          ? Colors.black
                                          : Colors.white,
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
                                        color: selectedIndex == 1
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      height: 2,
                                      width: screenWidth * 0.35,
                                      color: selectedIndex == 1
                                          ? Colors.black
                                          : Colors.white,
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
          // Sliding Settings panel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 0,
            bottom: 0,
            left: isSettingsOpen ? 0 : -screenWidth * 0.75,
            child: SizedBox(
              width: screenWidth * 0.75,
              child: GestureDetector(
                onTap: () {}, // absorb taps
                child: SettingsPanel(
                  onClose: () {
                    setState(() {
                      isSettingsOpen = false;
                    });
                  },
                ),
              ),
            ),
          ),
          if(isSettingsOpen)
          GestureDetector(
            onTap: (){
              setState(() {
                isSettingsOpen = false;
              });
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            )
          ),
        ],
      ),
    );
  }
}