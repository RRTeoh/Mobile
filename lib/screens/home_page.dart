import 'package:flutter/material.dart';
import 'package:asgm1/details/course.dart';
import 'package:asgm1/details/promotion.dart';
import 'package:asgm1/settings.dart';
import 'package:asgm1/screens/Promo1.dart';
import 'package:intl/intl.dart';
import 'package:asgm1/screens/viewscheduled.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asgm1/screens/Course_page.dart';
import 'package:asgm1/screens/course_details.dart';
import 'package:asgm1/nutrition_widgets/calorie_service.dart';
import 'package:asgm1/screens/notification_settings.dart';
import 'package:asgm1/services/notification_service.dart';
import 'package:asgm1/screens/notification_test.dart';
import 'package:asgm1/screens/heartbeat_page.dart';

//import 'package:asgm1/details/date.dart';
class HomePage extends StatefulWidget {
  final Function(VoidCallback)? onRefreshCalories;
  final Function(int)? onTabChanged;
  final VoidCallback? onNavigateToNutrition;
  const HomePage({super.key, this.onRefreshCalories, this.onTabChanged, this.onNavigateToNutrition});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<CourseDetails> detailedCourses = CourseDetails.getAllCourse();
  final List<Course> courses = [];
  final List<Promotion> promotion = [];
  // int promotionIndex = 1;
  // final List<Widget> pages = [
  //   //Promo1(),
  //   //Promo2(),
  //   //Promo3(),
  // ];
  
  //final List<Date> dates = [];
  bool isSettingsOpen = false;
  Map<String, dynamic>? _nextEvent;
  bool _loadingEvent = true;
  
  // Calorie-related status
  int _remainingCalories = 2000;
  bool _isLoadingCalories = true;

  @override
  void initState() {
    super.initState();
    _fetchNextEvent();
    _loadCalories();
    // Setting the Refresh Callback
    widget.onRefreshCalories?.call(refreshCalories);
  }

  Future<void> _loadCalories() async {
    try {
      final remainingCalories = await CalorieService.getRemainingCalories();
      if (mounted) {
        setState(() {
          _remainingCalories = remainingCalories;
          _isLoadingCalories = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _remainingCalories = 2000;
          _isLoadingCalories = false;
        });
      }
    }
  }

  // Method to refresh calorie data, for external use
  void refreshCalories() {
    _loadCalories();
  }

  Future<void> _fetchNextEvent() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final scheduleRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('schedule');
      final snapshot = await scheduleRef.get();
      final tomorrow = DateFormat('d MMMM yyyy').format(DateTime.now().add(const Duration(days: 1)));
      final events = snapshot.docs
          .map((doc) => doc.data())
          .where((data) => data['date'] == tomorrow)
          .toList();
      setState(() {
        _nextEvent = events.isNotEmpty ? events.first : null;
        _loadingEvent = false;
      });
    } else {
      setState(() {
        _nextEvent = null;
        _loadingEvent = false;
      });
    }
  }

  // Build calorie display component
  Widget _buildCalorieDisplay() {
    final isNegative = _remainingCalories < 0;
    final backgroundColor = isNegative 
        ? Colors.green 
        : const Color.fromARGB(255, 214, 233, 249);
    
    return GestureDetector(
      onTap: () {
        // Navigate to nutrition page within tracking page
        widget.onNavigateToNutrition?.call();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: _isLoadingCalories
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                )
              : isNegative
                  ? const Text(
                      '✓',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    )
                  : Column(
                      children: [
                        const SizedBox(height: 18),
                        Text(
                          "${_remainingCalories}kcal",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          "Remaining",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final courses = Course.getAllCourse();
    final promotion = Promotion.getAllPromo();
    //final dates = Date.getAllDate();
    final screenWidth = MediaQuery.of(context).size.width;
    //final screenHeight = MediaQuery.of(context).size.height;
    final DateTime today = DateTime.now();// Replace with DateTime.now() in production
    final int weekday = today.weekday; // Monday = 1
    final DateTime monday = today.subtract(Duration(days: weekday - 1));

    final List<Map<String, String>> instructors = [
    {"name": "Oliva Mitchell", "image": "assets/images/trainers/Trainer6.jpg"},
    {"name": "Lin Xiny", "image": "assets/images/trainers/Trainer2.jpg"},
    {"name": "Zoe Blake", "image": "assets/images/trainers/Trainer4.jpg"},
    {"name": "Mark", "image": "assets/images/trainers/Trainer8.jpg"},
  ];
      final List<Map<String, dynamic>> weekDates = List.generate(7, (index) {
    DateTime day = monday.add(Duration(days: index));
    return {
      'label': DateFormat('E').format(day), // 'Mon', 'Tue', etc.
      'day': day.day,
      'isToday': day.day == today.day &&
                 day.month == today.month &&
                 day.year == today.year,
    };
    });
    final String todayStr = DateFormat('d MMM yyy').format(DateTime.now());
    final String displayedDate = DateFormat('d MMM yyy').format(DateTime.now());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,

    // Title: list icon when settings are closed
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
      // actions: notification settings button removed
      actions:[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: CircleAvatar(
              radius: 23,
              backgroundImage: AssetImage("assets/images/noprofile.png"),
            ),
          ),
          ]
      ),
      
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,   // start from top
                end: Alignment.bottomCenter,  // end at bottom
                colors: [Color(0xff8fd4e8), Colors.white],
                stops: [
                  0.0, // sharp or not
                  0.8, // blue part
                ],
              ),
            ),
            child: ListView(
              children: 
              [
                Padding(
              padding: EdgeInsets.only(left: 20, top:0, bottom:20), // right:30),
              child: 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Today",
                  style: TextStyle(
                    fontSize: 15, 
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                ),
                SizedBox(height:2),
                Text(
                  displayedDate,
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: displayedDate == todayStr
                      ? const Color.fromARGB(255, 12, 0, 143)
                      : Colors.grey,
                  ),
                ),
                SizedBox(height:10),
                Container(
                  height: 200,
                  width: 320,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child:Column(
                    children: [
                    SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: weekDates.map((date) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          height: 85,
                          width: 38,
                          decoration: BoxDecoration(
                            color: date['isToday']
                                ? const Color.fromARGB(255, 12, 0, 143)
                                : const Color.fromARGB(255, 233, 233, 233),
                            borderRadius: BorderRadius.circular(75),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              Text(
                                date['label'],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: date['isToday'] ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  date['day'].toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //25%,calories,reminder
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HeartbeatPage(bpm: 117)),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 15),
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 214, 233, 249),
                            shape: BoxShape.circle,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.favorite, color: Color(0xFF0A84FF), size: 18),
                              SizedBox(height: 2),
                              Text(
                                '117 bpm',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),


                      SizedBox(width:10),
                      _buildCalorieDisplay(),
                      SizedBox(width:10),
                      GestureDetector(
                        onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MySchedulePage()),
                        );
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
                          height: 60,
                          width: 160,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 214, 233, 249),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                const Text(
                                  "Tomorrow",
                                  style: TextStyle(fontSize: 12, color: Colors.black),
                                ),
                                _loadingEvent
                                  ? const CircularProgressIndicator()
                                  : _nextEvent != null
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _nextEvent!['subtitle'] ?? '',
                                              style: const TextStyle(fontSize: 10, color: Colors.black),
                                            ),
                                            Text(
                                              _nextEvent!['title'] ?? '',
                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
                                            ),
                                          ],
                                        )
                                      : const Text(
                                          'No upcoming events',
                                          style: TextStyle(fontSize: 12, color: Colors.black),
                                        ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  )
                ],
                )
                ),      
                SizedBox(height:20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Courses",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            //fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 175,
                  //width: 150, // set height to show items horizontally
                  child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      final selectedCourse = courses[index];
                      final matchedDetail = detailedCourses.firstWhere(
                        (detail) => detail.coursename == selectedCourse.coursename,
                        orElse: () => CourseDetails(
                          courseimage: '',
                          coursename: selectedCourse.coursename,
                          videoUrl: '',
                          duration: '',
                          difficulty: '',
                          description: 'Details not available.',
                        ),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailsPage(
                            videoUrl: matchedDetail.videoUrl,
                            title: matchedDetail.coursename,
                            duration: matchedDetail.duration,
                            difficulty: matchedDetail.difficulty,
                            description: matchedDetail.description,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
                      height: 175,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 214, 233, 249),
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(courses[index].courseimage),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            padding: EdgeInsets.only(left: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              courses[index].coursename,
                              style: TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  },
                  ),
                ),
                SizedBox(height:15),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Services",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        //fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black),
                  ],
                ),

                SizedBox(
                  height: 175,
                  //width: 150, // set height to show items horizontally
                  child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: promotion.length,
                  itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      promotion[index].promoimage,
                                      width: double.infinity,
                                      height: 180,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    promotion[index].promoname,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    promotion[index].description,
                                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },

                   child:Container(
                    margin: EdgeInsets.only(right: 8),
                      height: 175,
                      width: 150,
                      decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 214,233,249),
                      ),
                      child: Column(
                        children: [
                          
                          Container(
                            margin:EdgeInsets.only(top:10),
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: 
                              DecorationImage(
                                image: AssetImage(promotion[index].promoimage),
                                fit: BoxFit.cover
                                )
                            ),
                          ),
                          Container(
                            margin:EdgeInsets.only(top:5, left:5, right:5),
                            padding: EdgeInsets.only(left: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              promotion[index].promoname,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                //fontWeight: FontWeight.bold
                            )
                          )
                          ),
                        ]
                      )
                      
                    )
                  );
                  },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Instructors",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: instructors.length,
                    itemBuilder: (context, index) {
                      final instructor = instructors[index];
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: Image.asset(
                                instructor['image']!,
                                fit: BoxFit.cover,
                                width: 150,
                                height: 190,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              instructor['name']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Fitness Instructors', // Placeholder for position
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              ],//final
                ),
              )

              ]
            ),
            ),  
          // Sliding Settings panel
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

