import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MySchedulePage extends StatefulWidget {
  const MySchedulePage({super.key});

  @override
  State<MySchedulePage> createState() => _MySchedulePageState();
}

class _MySchedulePageState extends State<MySchedulePage> {
  List<Map<String, dynamic>> _bookedCourses = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserSchedule();
  }

  Future<void> _loadUserSchedule() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final scheduleRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('schedule');
      final snapshot = await scheduleRef.get();
      setState(() {
        _bookedCourses = snapshot.docs.map((doc) => doc.data()).toList();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Schedule",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff8fd4e8), Colors.white],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 5),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _bookedCourses.isEmpty
                      ? const Center(child: Text("No courses added to schedule."))
                      : _buildGroupedScheduleList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupedScheduleList() {
    // Group courses by date
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var course in _bookedCourses) {
      final date = course['date'] ?? '';
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(course);
    }
    // Sort dates
    final sortedDates = grouped.keys.toList()
      ..sort((a, b) {
        try {
          final da = DateFormat('d MMMM yyyy').parse(a);
          final db = DateFormat('d MMMM yyyy').parse(b);
          return da.compareTo(db);
        } catch (_) {
          return a.compareTo(b);
        }
      });
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedDates.fold<int>(0, (prev, date) => prev + (grouped[date]?.length ?? 0) + 1),
      itemBuilder: (context, idx) {
        int runningIdx = 0;
        for (final date in sortedDates) {
          // Date header
          if (idx == runningIdx) {
            return Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 5),
              child: Text(
                date,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            );
          }
          runningIdx++;
          // Course containers
          for (final course in grouped[date]!) {
            if (idx == runningIdx) {
              return Dismissible(
                key: Key('${course['title']}_${course['subtitle']}'),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  final removedCourse = course;
                  setState(() {
                    _bookedCourses.remove(course);
                  });
                  // Remove from Firestore
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    final scheduleRef = FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('schedule');
                    final snapshot = await scheduleRef
                        .where('title', isEqualTo: removedCourse['title'])
                        .where('subtitle', isEqualTo: removedCourse['subtitle'])
                        .get();
                    for (var doc in snapshot.docs) {
                      await doc.reference.delete();
                    }
                  }
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.redAccent,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: _buildCourseCard(course),
              );
            }
            runningIdx++;
          }
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    final List<Color> colors = [
      const Color.fromARGB(255, 174, 201, 244),
      const Color.fromARGB(255, 149, 208, 240),
      const Color.fromARGB(255, 159, 243, 236)
    ];
    final Color background =
        colors[course['title'].hashCode % colors.length];
    final String trainerImage = course['teacherimagepath'] ?? 'assets/images/trainers/Trainer1.jpg';
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(course['title'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 4),
                  Text(course['subtitle'], style: const TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: AssetImage(trainerImage),
                  ),
                  const SizedBox(width: 6),
                  Text(course['teachername'] ?? "Trainer",
                      style: const TextStyle(fontSize: 12)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_horiz, size: 20),
                    onPressed: () {
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
                              padding: const EdgeInsets.only(left: 20),
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            course['title'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Container(
                                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                                            height: 25,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 218, 218, 218),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            padding: const EdgeInsets.all(5),
                                            child: Text(
                                              course['classmode'] ?? '',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 20),
                                        child: Container(
                                          height: 200,
                                          width: 350,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            image: DecorationImage(
                                              image: AssetImage(course['imagePath'] ?? ''),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 23,
                                            backgroundImage: AssetImage(course['teacherimagepath'] ?? ''),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Trainer",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                course['teachername'] ?? '',
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              RatingBar.builder(
                                                initialRating: (course['rating'] is num)
                                                    ? (course['rating'] as num).toDouble()
                                                    : 0.0,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                itemSize: 10,
                                                itemBuilder: (context, _) => const Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                ),
                                                onRatingUpdate: (double value) {},
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                                const SizedBox(width: 5),
                                                Text(
                                                  course['subtitle'] ?? '',
                                                  style: const TextStyle(fontSize: 10, color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                const Icon(Icons.calendar_month, size: 14, color: Colors.red),
                                                const SizedBox(width: 5),
                                                Text(
                                                  course['date'] ?? '',
                                                  style: const TextStyle(fontSize: 10, color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                const Icon(Icons.location_on, size: 14, color: Colors.blue),
                                                const SizedBox(width: 5),
                                                Text(
                                                  course['address'] ?? '',
                                                  style: const TextStyle(fontSize: 10, color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 20),
                                              child: Text(
                                                course['description'] ?? '',
                                                textAlign: TextAlign.justify,
                                                style: const TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
