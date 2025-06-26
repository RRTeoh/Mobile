import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class MySchedulePage extends StatelessWidget {
  final List<Map<String, dynamic>> bookedCourses;

  const MySchedulePage({super.key, this.bookedCourses = const []});

  // Group courses by date
  Map<String, List<Map<String, dynamic>>> _groupCoursesByDate() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var course in bookedCourses) {
      final date = course['date']; // Expected: "Tuesday, July 9"
      grouped.putIfAbsent(date, () => []).add(course);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedCourses = _groupCoursesByDate();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Schedule",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff8fd4e8), Colors.white],
          ),
        ),
        child: groupedCourses.isEmpty
            ? const Center(child: Text("No courses added to schedule."))
            : ListView(
                children: groupedCourses.entries.map((entry) {
                  final date = entry.key;
                  final courses = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color.fromARGB(255, 125, 125, 125)),
                      ),
                      const SizedBox(height: 10),
                      ...courses.map((course) => _buildCourseCard(course)).toList(),
                      if (entry != groupedCourses.entries.last)
                        const SizedBox(height: 20),
                    ],
                  );
                }).toList(),
              ),
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    final List<Color> colors = [const Color.fromARGB(255, 156, 217, 255), const Color.fromARGB(255, 118, 180, 255), const Color.fromARGB(255, 143, 223, 230)];
    final Color background = colors[course['title'].hashCode % colors.length];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(course['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
              const CircleAvatar(radius: 12, backgroundImage: AssetImage('assets/trainer.png')),
              const SizedBox(width: 6),
              Text(course['teachername'] ?? "Trainer", style: const TextStyle(fontSize: 12)),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
