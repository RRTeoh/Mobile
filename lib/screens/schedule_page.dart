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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            height: 247,
            color: Colors.lightBlue.shade100,
          ),

          // AppBar manually placed inside Stack
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
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
              )

            ),
          ),
          Positioned(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 8, // small space below app bar
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //color: Colors.lightBlue.shade100, // optional background for clarity
              decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.lightBlue.shade100, Colors.white],
              ),
            ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search bar for courses
                  SizedBox(
                    height: 40, // smaller height
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search for classes",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, size: 20),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        isDense: true, //strink the height of text field
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),

                  SizedBox(height: 8),

                  // Search bar for location
                  SizedBox(
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search location",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.location_on, size: 20),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Button
                  SizedBox(
                    width: 150, // full width
                    height: 36, // smaller height
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
                                  primary: Colors.lightBlue, // header background color
                                  onPrimary: Colors.white, // header text color
                                  onSurface: Colors.black, // body text color
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.lightBlue, // button text color
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;  // <--- assign pickedDate here
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue.shade100,
                        foregroundColor: Colors.black,//text color to white
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

          // Tap-to-close transparent overlay
          if (isSettingsOpen)
            GestureDetector(
              onTap: () {
                setState(() {
                  isSettingsOpen = false;
                });
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }

}
