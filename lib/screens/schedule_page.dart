import 'package:flutter/material.dart';
import 'package:asgm1/details/schedulecourse.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:asgm1/settings.dart';
import 'package:asgm1/screens/viewscheduled.dart';

class SearchCourse extends StatefulWidget {
  const SearchCourse({super.key});

  @override
  State<SearchCourse> createState() => _SearchCourseState();
}

class _SearchCourseState extends State<SearchCourse> {
  bool isSettingsOpen = false;
  DateTime? selectedDate;
  final List<Schedulecourse> _allCourse = Schedulecourse.getAllSC();
  List<Schedulecourse> _foundCourse = [];
  Set<int> addedCourseIndices = {};


  @override
  void initState() {
    _foundCourse = _allCourse;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<Schedulecourse> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allCourse;
    } else {
      results = _allCourse
          .where((scourse) => scourse.title
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundCourse = results;
    });
  }

  void _runFilterL(String enteredKeyword) {
    List<Schedulecourse> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allCourse;
    } else {
      results = _allCourse
          .where((scourse) => scourse.address
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundCourse = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Gradient Area
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,   // start from top
                end: Alignment.bottomCenter,  // end at bottom
                colors: [Color(0xff8fd4e8), Colors.white],
                stops: [
                  0.0, // sharp or not
                  0.6, // blue part
                ],
              ),
            ),),

          // Custom AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: SizedBox(
                height: kToolbarHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!isSettingsOpen)
                      IconButton(
                        icon: const Icon(Icons.list, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            isSettingsOpen = true;
                          });
                        },
                      ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Text(
                        "Gym Schedule",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  )
                ),
              //),
            ),
          ),

          // Search Bar + Button Area
          Positioned(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 8,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                  color: Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Class Search
                  SizedBox(
                    height: 40,
                    child: TextField(
                      onChanged: _runFilter,
                      decoration: InputDecoration(
                        hintText: "Search for classes",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, size: 20),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 8),

                  // Location Search
                  SizedBox(
                    height: 40,
                    child: TextField(
                      onChanged: _runFilterL,
                      decoration: InputDecoration(
                        hintText: "Search location",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.location_on, size: 20),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Schedule + View Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Schedule Your Date Button
                      SizedBox(
                        width: 150,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(DateTime.now().year, DateTime.now().month),
                              lastDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Colors.lightBlue,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.lightBlue,
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue.shade200,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            selectedDate == null
                                ? "Schedule Your Date"
                                : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // View My Schedule Button
                      SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to MySchedulePage (you must define and pass your booked list)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MySchedulePage(
                                  bookedCourses: _foundCourse
                                    .asMap()
                                    .entries
                                    .where((entry) => addedCourseIndices.contains(entry.key))
                                    .map((entry) => {
                                      'title': entry.value.title,
                                      'subtitle': entry.value.subtitle,
                                      'date': entry.value.date,
                                      'teachername': entry.value.teachername,
                                    })
                                    .toList(),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue.shade200,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("View My Schedule", style: TextStyle(fontSize: 12, color: Colors.black)),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),

          // Settings Drawer Panel
          

          //if(!isSettingsOpen)// Course List Area
          Positioned(
            top: 247,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _foundCourse.isNotEmpty
                          ? ListView.builder(
                            itemCount: _foundCourse.length,
                            itemBuilder: (context, index) => Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 3,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                  // Left Side
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _foundCourse[index].time,
                                              //'10:00',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.cyan,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Container(
                                            padding: EdgeInsets.only(left:15),
                                            child:Text(
                                          //'1hr',
                                            _foundCourse[index].duration,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ), 
                                          )
                                        ],
                                    ),
                                    SizedBox(width: 16),

                                    // Middle
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            //'BODY BALANCE',
                                            _foundCourse[index].title,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.access_time, size: 14, color: Colors.grey),
                                              SizedBox(width: 4),
                                              Text(
                                                //'10:00 am - 11:00 am',
                                                _foundCourse[index].subtitle,
                                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                              ),
                                              ],
                                          ),
                                          SizedBox(height: 4),
                                          RatingBar.builder(
                                            initialRating: _foundCourse[index].rating.toDouble(),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            itemSize: 20,
                                            itemBuilder: (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.yellow
                                              ),
                                            onRatingUpdate: (double value) { },
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Right side (+ button)
                                    Padding(
                                      padding: EdgeInsets.only(top: 50), // Pushes the whole circle down
                                        child:Container(
                                        height: 30,
                                        width: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: addedCourseIndices.contains(index) ?Colors.green: Colors.cyan,
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          addedCourseIndices.contains(index) ?Icons.check:Icons.add, 
                                          color: Colors.white,
                                          size: 20,
                                          ),
                                        onPressed: () {
                                          Schedulecourse course = _foundCourse[index];
                                        // Handle add action
                                        showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return SingleChildScrollView(
                                  child: Container(
                                    height: 500,
                                    padding: const EdgeInsets.only(left:20),
                                    width: MediaQuery.of(context).size.width,
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            //const SizedBox(height: 40),
                                            Row(
                                              children: [
                                                Text(
                                                  course.title,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                  )
                                                ),
                                                SizedBox(width:10),
                                                Container(
                                                margin:EdgeInsets.only(top:10,bottom:10),
                                                  height:25,
                                                  width:60,
                                                    decoration: BoxDecoration(
                                                    color: const Color.fromARGB(255, 218, 218, 218),
                                                    borderRadius: BorderRadius.circular(15),
                                                    
                                                ),
                                                padding: EdgeInsets.all(5),
                                                  child: Text(
                                                    course.classmode,
                                                    textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black
                                                      )
                                                  )
                                                ),
                                              ],
                                            ),
                                                  Padding(
                                                    padding: EdgeInsets.only(right:20),
                                                    child:Container(
                                                    height: 200,
                                                    width: 350,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                      image: 
                                                      DecorationImage(
                                                      image: AssetImage(course.imagePath),
                                                      fit: BoxFit.cover
                                                    )
                                                    ),
                                                  ),
                                                  ),
                                                  const SizedBox(height:15),
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 23,
                                                        backgroundImage: AssetImage(course.teacherimagepath),
                                                      ),
                                                      SizedBox(width:10),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Trainer",
                                                            textAlign: TextAlign.left,
                                                            style:TextStyle(
                                                              fontSize: 10,
                                                              color:Colors.grey
                                                            )
                                                          ),
                                                          Text(
                                                            course.teachername,
                                                            textAlign: TextAlign.left,
                                                            style:TextStyle(
                                                              fontSize: 15,
                                                              color:Colors.black
                                                            )
                                                          ),
                                                          RatingBar.builder(
                                                          initialRating: course.rating.toDouble(),
                                                          minRating: 1,
                                                          direction: Axis.horizontal,
                                                          itemSize: 10,
                                                          itemBuilder: (context, _) => const Icon(
                                                          Icons.star,
                                                          color: Colors.yellow
                                                          ),
                                                          onRatingUpdate: (double value) { },
                                                          ),
                                                        ],
                                                      )

                                                    ]
                                                  ),
                                                  SizedBox(height:10),
                                                  Padding(
                                                    padding: EdgeInsets.only(left:10),
                                                    child:Column(
                                                    children: 
                                                    [
                                                      Row(
                                                      children:[Icon(Icons.access_time, size: 14, color: Colors.grey),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        course.subtitle,
                                                        style: TextStyle(fontSize: 10, color: Colors.black),
                                                      ),
                                                      ]
                                                      ),
                                                      SizedBox(height: 5),
                                                      Row(
                                                      children:[Icon(Icons.calendar_month, size: 14, color: Colors.red),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        course.date,
                                                        style: TextStyle(fontSize: 10, color: Colors.black),
                                                      ),
                                                      ]
                                                      ),
                                                      SizedBox(height: 5),
                                                      Row(
                                                      children:[Icon(Icons.location_on, size: 14, color: Colors.blue),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        course.address,
                                                        style: TextStyle(fontSize: 10, color: Colors.black),
                                                      ),
                                                      ]
                                                      ),
                                                      SizedBox(height:10),
                                                      Padding(
                                                        padding: EdgeInsets.only(right:20),
                                                        child:Text(
                                                        course.description,
                                                        textAlign: TextAlign.justify,
                                                        style: TextStyle(
                                                          fontSize: 8,
                                                          color: Colors.black
                                                        )
                                                      )
                                                      ),
                                                      SizedBox(height:10),
                                                        StatefulBuilder(
                                                          builder: (BuildContext context, StateSetter setModalState) {
                                                            return ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: addedCourseIndices.contains(index)
                                                                    ? Colors.greenAccent.shade200
                                                                    : const Color.fromARGB(255, 22, 45, 180),
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  addedCourseIndices.add(index); // update main screen
                                                                });
                                                                setModalState(() {}); // update modal button state
                                                              },
                                                              child: Text(
                                                                addedCourseIndices.contains(index)
                                                                    ? "Added"
                                                                    : "+ Add to my schedule",
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: addedCourseIndices.contains(index)
                                                                      ? Colors.black
                                                                      : Colors.white,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                    ],),
                                                  )
                                                ],
                                              ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                                      )
                                        
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ): const Text(
                            "No results found. Please try with different search",
                            style: TextStyle(fontSize: 22),
                          
                          )
            ),
          ),

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

//   Widget _buildCourseDetails(
//       BuildContext context, Schedulecourse course, int index) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       height: 500,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(course.title,
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           SizedBox(height: 10),
//           Container(
//             height: 180,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(course.imagePath),
//                 fit: BoxFit.cover,
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           SizedBox(height: 10),
//           Text("Trainer: ${course.teachername}",
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
//           SizedBox(height: 5),
//           Text("Duration: ${course.duration}"),
//           Text("Time: ${course.subtitle}"),
//           Text("Date: ${course.date}"),
//           Text("Location: ${course.address}"),
//           SizedBox(height: 10),
//           Text(course.description, textAlign: TextAlign.justify),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 addedCourseIndices.add(index);
//               });
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: addedCourseIndices.contains(index)
//                   ? Colors.greenAccent
//                   : Colors.blueAccent,
//             ),
//             child: Text(
//               addedCourseIndices.contains(index)
//                   ? "Added"
//                   : "+ Add to my schedule",
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
 }