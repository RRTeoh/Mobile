import 'package:flutter/material.dart';
import 'package:asgm1/details/add_card.dart';
import 'package:asgm1/details/stat_card.dart';
import 'package:asgm1/details/workout_card.dart';
import 'package:asgm1/screens/calories_burned_page.dart';
import 'package:asgm1/screens/heartbeat_page.dart';
import 'package:asgm1/screens/steps_details_page.dart';
import 'package:asgm1/details/workout_model.dart';
import 'package:asgm1/details/workout_service.dart';
import 'package:asgm1/screens/add_workout_page.dart'; // or wherever your AddExercisePage is


class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});
  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final WorkoutService _service = WorkoutService();

  void showEditWorkoutDialog(Workout w) {
    final timeCtrl = TextEditingController(text: w.time.replaceAll(":00", ""));
    final repsCtrl = TextEditingController(text: w.reps.replaceAll(" reps", ""));

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFFEAF6FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Edit ${w.label}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: timeCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Time'),
              ),
              TextField(
                controller: repsCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Reps'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context); // close dialog
                      await _service.deleteWorkout(w.id);
                    },
                    child: const Text("Delete", style: TextStyle(color: Colors.red)),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          w.time = "${timeCtrl.text}:00";
                          w.reps = "${repsCtrl.text} reps";
                          await _service.updateWorkout(w);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A84FF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<List<Workout>>(
        stream: _service.streamWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final workouts = snapshot.data ?? [];

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              children: [
                                const SizedBox(width: 8),
                                for (final w in workouts)
                                  WorkoutCard(
                                    w.time,
                                    w.label,
                                    w.reps,
                                    w.imagePath,
                                    onTap: () => showEditWorkoutDialog(w),
                                  ),
                                AddCard(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const AddExercisePage()),
                                    );

                                    if (result != null && result is List<Exercise>) {
                                      for (final exercise in result) {
                                        final newWorkout = Workout(
                                          id: '', // Firestore will generate
                                          time: "${exercise.minutes}:00",
                                          label: exercise.name,
                                          reps: "${exercise.exercises} reps",
                                          imagePath: exercise.imagePath,
                                        );
                                        await _service.addWorkout(newWorkout);
                                      }
                                    }
                                  },
                                ),

                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Statistics
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
                          children: [
                            StatCard(
                              Icons.favorite,
                              "117",
                              "bpm",
                              "assets/images/heartbeat.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HeartbeatPage()),
                                );
                              },
                            ),
                            const SizedBox(width: 16),
                            StatCard(
                              Icons.directions_walk,
                              "3680",
                              "steps",
                              "assets/images/footsteps.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const StepsDetailPage()),
                                );
                              },
                            ),
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
                                    Text("Analytics", style: TextStyle(fontWeight: FontWeight.bold)),
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
          );
        },
      ),
    );
  }
}
