import 'package:flutter/material.dart';
import 'package:asgm1/details/workout_model.dart';

class Exercise {
  final String name;
  final String imagePath;
  final int exercises;
  final int minutes;

  Exercise({
    required this.name,
    required this.imagePath,
    required this.exercises,
    required this.minutes,
  });
}

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({super.key});

  @override
  State<AddExercisePage> createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Exercise> _allExercises = [
    Exercise(name: 'Push-ups', imagePath: 'assets/images/exercise/pushup.png', exercises: 30, minutes: 10),
    Exercise(name: 'Sit-ups', imagePath: 'assets/images/exercise/situp.png', exercises: 50, minutes: 12),
    Exercise(name: 'Jumping Jacks', imagePath: 'assets/images/exercise/jumpingjacks.png', exercises: 40, minutes: 15),
    Exercise(name: 'Plank', imagePath: 'assets/images/exercise/plank.png', exercises: 1, minutes: 3),
    Exercise(name: 'Squats', imagePath: 'assets/images/exercise/squats.png', exercises: 25, minutes: 7),
    Exercise(name: 'Lunges', imagePath: 'assets/images/exercise/lunges.png', exercises: 20, minutes: 8),
    Exercise(name: 'Mountain Climbers', imagePath: 'assets/images/exercise/mountainclimbers.png', exercises: 40, minutes: 5),
    Exercise(name: 'High Knees', imagePath: 'assets/images/exercise/highknees.png', exercises: 50, minutes: 6),
    Exercise(name: 'Run', imagePath: 'assets/images/exercise/run.png', exercises: 1, minutes: 30),
    Exercise(name: 'Swim', imagePath: 'assets/images/exercise/swim.png', exercises: 1, minutes: 40),
    Exercise(name: 'Rowing', imagePath: 'assets/images/exercise/rowing.png', exercises: 1, minutes: 20),
    Exercise(name: 'Cycling', imagePath: 'assets/images/exercise/cycling.png', exercises: 1, minutes: 35),
  ];

  List<Exercise> _filteredExercises = [];

  @override
  void initState() {
    super.initState();
    _filteredExercises = List.from(_allExercises);

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredExercises = _allExercises
            .where((ex) => ex.name.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showInputDialog(Exercise exercise) {
    final repsController = TextEditingController();
    final minutesController = TextEditingController();

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
              Text("Log ${exercise.name}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Reps',
                  border: UnderlineInputBorder(),
                ),
              ),
              TextField(
                controller: minutesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Minutes',
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final reps = int.tryParse(repsController.text) ?? 0;
                      final minutes = int.tryParse(minutesController.text) ?? 0;

                      Navigator.pop(context); // close dialog
                      Navigator.pop(context, [
                        Exercise(
                          name: exercise.name,
                          imagePath: exercise.imagePath,
                          exercises: reps,
                          minutes: minutes,
                        )
                      ]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A84FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Save"),
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
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8FD4E8), Color(0xFFEAF6FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // AppBar
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, size: 22, color: Colors.black),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Add Workout',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),


              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search workout...',
                    prefixIcon: const Icon(Icons.search, color: Colors.blueGrey),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Exercise List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredExercises.length,
                  itemBuilder: (context, index) {
                    final ex = _filteredExercises[index];
                    return GestureDetector(
                      onTap: () => _showInputDialog(ex),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade100.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                ex.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                ex.imagePath,
                                width: 90,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
