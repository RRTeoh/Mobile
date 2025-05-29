import 'package:flutter/material.dart';

class Exercise {
  final String name;
  final String imagePath;
  bool isSelected;

  Exercise({
    required this.name,
    required this.imagePath,
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
    Exercise(name: 'Forward Lunge', imagePath: 'assets/images/forward_lunge.png'),
    Exercise(name: 'Burpee', imagePath: 'assets/images/burpee.png'),
    Exercise(name: 'Plank', imagePath: 'assets/images/plank.png'),
    Exercise(name: 'Air Squat', imagePath: 'assets/images/air_squat.png'),
    Exercise(name: 'Butterfly Situp', imagePath: 'assets/images/butterfly_situp.png'),
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
    final cardColor = const Color(0xFF85C1F9);
    final selectedColor = Colors.blue.shade700;
    final unselectedColor = Colors.grey.shade300;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F4FF), // Light background matching screenshot
      appBar: AppBar(
        title: const Text('Add Exercise'),
        backgroundColor: cardColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search exercises',
                prefixIcon: const Icon(Icons.search, color: Colors.blueGrey),
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Exercise list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = _filteredExercises[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade100.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        exercise.imagePath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    ),
                    title: Text(
                      exercise.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        setState(() {
                          exercise.isSelected = !exercise.isSelected;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: exercise.isSelected ? selectedColor : unselectedColor,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          exercise.isSelected ? Icons.check : Icons.circle_outlined,
                          color: exercise.isSelected ? Colors.white : Colors.grey.shade700,
                          size: 22,
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        exercise.isSelected = !exercise.isSelected;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Add Selected button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 4,
                  shadowColor: cardColor.withOpacity(0.6),
                ),
                onPressed: _onAddSelected,
                child: const Text(
                  'Add Selected',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
