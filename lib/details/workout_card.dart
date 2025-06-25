import 'package:flutter/material.dart';

class WorkoutCard extends StatelessWidget {
  final String time;
  final String label;
  final String value;
  final String imagePath;
  final VoidCallback? onTap;

  const WorkoutCard(this.time, this.label, this.value, this.imagePath, {this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        height: 130,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(time, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 18,
                child: ClipOval(
                  child: Image.asset(
                    imagePath,
                    width: 28,
                    height: 28,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.fitness_center, size: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 24,
                alignment: Alignment.center,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9),
                ),
              ),
              Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
