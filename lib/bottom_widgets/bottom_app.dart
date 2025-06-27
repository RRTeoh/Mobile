import 'package:flutter/material.dart';
import 'package:asgm1/screens/feed_page.dart';
import 'package:asgm1/screens/membership.dart';
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
  
  // Using callback functions to refresh calorie data
  VoidCallback? _refreshCaloriesCallback;

  // GlobalKey for TrackingPage to control navigation
  final GlobalKey<TrackerPageState> _trackingKey = GlobalKey<TrackerPageState>();

  // Methods for setting refresh callbacks
  void _setRefreshCallback(VoidCallback callback) {
    _refreshCaloriesCallback = callback;
  }

  // Method of refreshing calorie data
  void _refreshCalories() {
    _refreshCaloriesCallback?.call();
  }

  // Method to change tabs
  void _changeTab(int index) {
    setState(() {
      myCurrentIndex = index;
    });
  }

  // Method to navigate to nutrition page within tracking
  void _navigateToNutrition() {
    setState(() {
      myCurrentIndex = 3; // Switch to tracking tab
    });
    // Use a post-frame callback to ensure the page is built before switching tabs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackingKey.currentState?.switchToNutrition();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: myCurrentIndex,
        children: [
          HomePage(
            onRefreshCalories: _setRefreshCallback,
            onTabChanged: _changeTab,
            onNavigateToNutrition: _navigateToNutrition,
          ),
          SearchCourse(),
          FeedPage(),
          TrackingPage(
            key: _trackingKey,
            onCaloriesUpdated: _refreshCalories,
          ),
          ProfilePage(),
        ],
      ),

      // 🔘 FAB in the center
      floatingActionButton: Container(
        height: 65,
        width: 65,
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
        backgroundColor: const Color.fromARGB(255, 14, 115, 148), 
        child: Icon(
          Icons.home_rounded,
          size: 48,
          color: myCurrentIndex == 0? const Color.fromARGB(255, 12, 0, 143) : Colors.white,
        ),
      ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      
      bottomNavigationBar: BottomAppBar(
        height: 70,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        color:  Color(0xff8fd4e8),
        //child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            
            children: [
              //SizedBox(width: 0),
              // Left side icons
              IconButton(
                icon: Icon(
                  Icons.calendar_month_sharp,
                  size: 30,
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
              SizedBox(width: 25),
              IconButton(
                icon: Icon(
                  Icons.diversity_3_outlined,
                  size: 30,
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

              const SizedBox(width: 90), // Space for FAB

              // Right side icons
              IconButton(
                icon: Icon(
                  Icons.favorite_rounded,
                  size: 30,
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
                  size: 30,
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
