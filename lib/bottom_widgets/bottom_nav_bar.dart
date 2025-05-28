import 'package:flutter/material.dart';
import 'package:asgm1/screens/feed_page.dart';
import 'package:asgm1/screens/tracking_page.dart';
import 'package:asgm1/screens/home_page.dart';
import 'package:asgm1/screens/schedule_page.dart';
import 'package:asgm1/screens/membership.dart';

class NavBar extends StatefulWidget 
{
  const NavBar ({super.key});

  @override
  State<NavBar> createState() => _NavBarState(); 
}

class _NavBarState extends State<NavBar>
{
  int myCurrentIndex = 5;
  List pages = [
    SearchCourse(),
    FeedPage(),
    TrackingPage(),
    ProfilePage(),
    HomePage(),
  ];

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      bottomNavigationBar: Container(
        //margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        //decoration: BoxDecoration(
          //color: Colors.blueAccent,
        //),
        child: ClipRRect(
          //borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // used when bottom_navigation_bar has more than 3 items
          backgroundColor: const Color.fromARGB(255, 85, 127, 199),
          selectedItemColor: const Color.fromARGB(255, 12, 0, 143),
          unselectedItemColor: Colors.white,
          currentIndex: myCurrentIndex,
          onTap: (index){
            setState(() {
              myCurrentIndex = index;
            });
          },
          items: const[
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month_sharp), label: "Schedule"),
            BottomNavigationBarItem(icon: Icon(Icons.diversity_3_outlined), label: "Feed"),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Tracking"),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: "Profile"),
          ]
        ),
        ),
      ),
      body: pages[myCurrentIndex],
      floatingActionButton: Container(
        height: 65,
        width: 65,
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 5
          ),
            boxShadow: [
              BoxShadow() //later see need or not
            ]
        ),
        child: FloatingActionButton(
        onPressed: ()
        {
          setState(() {
            myCurrentIndex = 4;
          });
        },
        shape: CircleBorder(),
        backgroundColor: Colors.blueAccent,
        child: Icon(
          Icons.home_rounded,
          size: 45,
          color: myCurrentIndex == 0? Colors. white : Colors.blueAccent,
        ),
      ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}