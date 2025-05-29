import 'package:flutter/material.dart';
import 'package:asgm1/details/add_card.dart';
import 'package:asgm1/details/stat_card.dart';
import 'package:asgm1/details/workout_card.dart';
import 'package:asgm1/screens/calories_burned_page.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gradient Header Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [Color(0xff8fd4e8), Colors.white],
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   // stops: [
                //   //   0.0, // sharp or not
                //   //   0.9, // blue part
                //   // ],

                // ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(left:16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //const SizedBox(height: 20),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Daily\n',
                              style: TextStyle(fontSize: 20, color: Colors.black, height: 1),
                            ),
                            TextSpan(
                              text: 'Workout',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black, height: 1.2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: const [
                            SizedBox(width: 8),
                            WorkoutCard("10:00", "Push-ups", "30 reps", Icons.fitness_center),
                            WorkoutCard("12:00", "Sit-ups", "50 reps", Icons.accessibility_new),
                            WorkoutCard("15:00", "Jumping Jacks", "40 reps", Icons.directions_run),
                            AddCard(),
                            SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 0),
                  ),
                ],
              ),

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Performance Statistics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        StatCard(Icons.favorite, "117", "bpm", "assets/images/heartbeat.png"),
                        SizedBox(width: 16),
                        StatCard(Icons.directions_walk, "3680", "steps", "assets/images/footsteps.png"),
                      ],
                    ),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CaloriesBurnedPage()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFB3E5FC), Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Calories Burned 🔥", style: TextStyle(fontWeight: FontWeight.bold)),
                                Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "assets/images/calorieschart.png",
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
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