import 'package:flutter/material.dart';
import 'package:asgm1/details/schedulecourse.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:asgm1/settings.dart';

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
          Container(height: 247, color: Color(0xff8fd4e8)),

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
                ),
              ),
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
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff8fd4e8), Colors.white],
                ),
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

                  // Schedule Button
                  SizedBox(
                    width: 150,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year,
                              DateTime.now().month),
                          lastDate: DateTime(DateTime.now().year,
                              DateTime.now().month + 1, 0),
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
                        backgroundColor: Colors.lightBlue.shade100,
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
                ],
              ),
            ),
          ),

          // Settings Drawer Panel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 0,
            bottom: 0,
            left: isSettingsOpen ? 0 : -screenWidth * 0.75,
            child: SizedBox(
              width: screenWidth * 0.75,
              child: GestureDetector(
                onTap: () {},
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

          // Transparent overlay to close drawer
          if (isSettingsOpen)
            GestureDetector(
              onTap: () {
                setState(() {
                  isSettingsOpen = false;
                });
              },
              child: Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          
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
                      padding: const EdgeInsets.only(top: 10, bottom: 60),
                      itemBuilder: (context, index) {
                        final course = _foundCourse[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(course.title,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4),
                                Text(course.subtitle),
                                SizedBox(height: 4),
                                RatingBarIndicator(
                                  rating: course.rating.toDouble(),
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 18.0,
                                  direction: Axis.horizontal,
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                addedCourseIndices.contains(index)
                                    ? Icons.check_circle
                                    : Icons.add_circle_outline,
                                color: addedCourseIndices.contains(index)
                                    ? Colors.green
                                    : Colors.blue,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (context) => _buildCourseDetails(
                                      context, course, index),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "No results found. Please try a different search.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildCourseDetails(
      BuildContext context, Schedulecourse course, int index) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(course.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Container(
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(course.imagePath),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          SizedBox(height: 10),
          Text("Trainer: ${course.teachername}",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          SizedBox(height: 5),
          Text("Duration: ${course.duration}"),
          Text("Time: ${course.subtitle}"),
          Text("Date: ${course.date}"),
          Text("Location: ${course.address}"),
          SizedBox(height: 10),
          Text(course.description, textAlign: TextAlign.justify),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                addedCourseIndices.add(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: addedCourseIndices.contains(index)
                  ? Colors.greenAccent
                  : Colors.blueAccent,
            ),
            child: Text(
              addedCourseIndices.contains(index)
                  ? "Added"
                  : "+ Add to my schedule",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}