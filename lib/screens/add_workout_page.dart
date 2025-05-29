import 'package:flutter/material.dart';

class Exercise {
  final String name;
  final String imagePath;
  final int exercises;
  final int minutes;
  bool isSelected;

  Exercise({
    required this.name,
    required this.imagePath,
    required this.exercises,
    required this.minutes,
    this.isSelected = false,
  });
}

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({super.key});

  @override
  State<AddExercisePage> createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  final TextEditingController _searchController = TextEditingController();

  List<Exercise> _allExercises = [
    Exercise(name: 'Push-ups', imagePath: 'assets/images/yoga.png', exercises: 30, minutes: 10),
    Exercise(name: 'Sit-ups', imagePath: 'assets/images/pilates.png', exercises: 50, minutes: 12),
    Exercise(name: 'Jumping Jacks', imagePath: 'assets/images/full_body.png', exercises: 40, minutes: 15),
    Exercise(name: 'Plank', imagePath: 'assets/images/plank.png', exercises: 1, minutes: 3),
    Exercise(name: 'Squats', imagePath: 'assets/images/air_squat.png', exercises: 25, minutes: 7),
    Exercise(name: 'Lunges', imagePath: 'assets/images/forward_lunge.png', exercises: 20, minutes: 8),
    Exercise(name: 'Mountain Climbers', imagePath: 'assets/images/mountain_climber.png', exercises: 40, minutes: 5),
    Exercise(name: 'High Knees', imagePath: 'assets/images/high_knees.png', exercises: 50, minutes: 6),
    Exercise(name: 'Run', imagePath: 'assets/images/run.png', exercises: 1, minutes: 30),
    Exercise(name: 'Swim', imagePath: 'assets/images/swim.png', exercises: 1, minutes: 40),
    Exercise(name: 'Rowing', imagePath: 'assets/images/row.png', exercises: 1, minutes: 20),
    Exercise(name: 'Cycling', imagePath: 'assets/images/cycling.png', exercises: 1, minutes: 35),
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

  void _onAddSelected() {
    final selected = _allExercises.where((ex) => ex.isSelected).toList();
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one exercise')),
      );
      return;
    }
    Navigator.pop(context, selected);
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0A84FF);

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB8E3FF), Color(0xFFEAF6FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar style to match Analytics
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
                      onTap: () {
                        setState(() {
                          ex.isSelected = !ex.isSelected;
                        });
                      },
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
