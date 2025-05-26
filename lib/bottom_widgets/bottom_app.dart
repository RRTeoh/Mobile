import 'package:flutter/material.dart';
import 'package:asgm1/screens/feed_page.dart';
import 'package:asgm1/screens/profile_page.dart';
import 'package:asgm1/screens/tracking_page.dart';
import 'package:asgm1/screens/home_page.dart';
import 'package:asgm1/screens/schedule_page.dart';

class BottomApp extends StatefulWidget {
  const BottomApp({super.key});

  @override
  State<BottomApp> createState() => _BottomAppState();
}

class _BottomAppState extends State<BottomApp> {
  int myCurrentIndex = 0;

  final List<Widget> pages = [
    HomePage(),
    SearchCourse(),
    FeedPage(),
    TrackingPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[myCurrentIndex],

      // 🔘 FAB in the center
      floatingActionButton: Container(
        height: 80,
        width: 80,
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 0
          ),
            boxShadow: [
              BoxShadow() //later see need or not
            ]
        ),
        child: FloatingActionButton(
        onPressed: ()
        {
          setState(() {
            myCurrentIndex = 0;
          });
        },
        shape: CircleBorder(),
        backgroundColor: myCurrentIndex == 0? const Color.fromARGB(255, 172, 255, 251) :Color.fromARGB(255, 51, 107, 136), 
        child: Icon(
          Icons.home_rounded,
          size: 50,
          color: myCurrentIndex == 0? const Color.fromARGB(255, 12, 0, 143) : Colors.white,
        ),
      ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        color:  const Color.fromARGB(255, 51, 107, 136),
        //child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //SizedBox(width: 0),
              // Left side icons
              IconButton(
                icon: Icon(
                  Icons.calendar_month_sharp,
                  size: 40,
                  color: myCurrentIndex == 1
                      ? const Color.fromARGB(255, 12, 0, 143)
                      : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    myCurrentIndex = 1;
                  });
                },
              ),
              SizedBox(width: 30),
              IconButton(
                icon: Icon(
                  Icons.diversity_3_outlined,
                  size: 40,
                  color: myCurrentIndex == 2
                      ? const Color.fromARGB(255, 12, 0, 143)
                      : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    myCurrentIndex = 2;
                  });
                },
              ),

              const SizedBox(width: 100), // Space for FAB

              // Right side icons
              IconButton(
                icon: Icon(
                  Icons.favorite_rounded,
                  size: 40,
                  color: myCurrentIndex == 3
                      ? const Color.fromARGB(255, 12, 0, 143)
                      : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    myCurrentIndex = 3;
                  });
                },
              ),
              SizedBox(width: 20),
              IconButton(
                icon: Icon(
                  Icons.account_circle_rounded,
                  size: 40,
                  color: myCurrentIndex == 4
                      ? const Color.fromARGB(255, 12, 0, 143)
                      : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    myCurrentIndex = 4;
                  });
                },
              ),
              //SizedBox(width: 10),
            ],
          //),
        ),
      ),
    );
  }
}