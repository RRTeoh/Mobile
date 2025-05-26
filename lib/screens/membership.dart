import 'package:flutter/material.dart';
import 'package:asgm1/details/card.dart';
import 'package:asgm1/details/profile.dart';
import 'package:asgm1/details/myreward.dart';
import 'package:asgm1/details/payment.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Track selected tab (0 = My Rewards, 1 = Payment)
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Membership",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.filter_list, color: Colors.black),  
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlue.shade100, Colors.white],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: ProfileAvatar(
                  imagePath: 'assets/images/myprofile/people.jpg',
                  name: 'Jackson Wang',
                  streak: '145 🔥',
                ),
              ),
            ),
            const SizedBox(height: 10),
            const MembershipCard(
              imagePath1: 'assets/images/myprofile/membercard.jpg',
              imagePath2: 'assets/images/myprofile/barcode2.jpg',
            ),
            const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: selectedIndex == 0 ? Colors.black : Colors.grey, //is is 0 set to black, else set to grey
                                ),
                              ), 
                            const SizedBox(height: 5),
                            Container(
                              height: 2,
                              width: 130,
                              color: selectedIndex == 0? Colors.black : Colors.grey,
                              ), 
                            ],
                          ),  
                        ),
                        const SizedBox(width: 60), 
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: selectedIndex == 1 ? Colors.black : Colors.grey,
                                ),
                              ), 
                              const SizedBox(height: 5),
                              Container(
                                height: 2,
                                width: 130,
                                color: selectedIndex == 1? Colors.black : Colors.grey,
                                ), 
                            ],
                          ),
                        ),
                        ],
                      ),
                    ),
                    //Display content based on selected tab
                    Expanded(
                      child: selectedIndex == 0
                          ? const MyRewards() //if the index is 0, then myrewards page is true, show this page
                          : const MyPayment(), // else index is 1, then payment page is show
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}