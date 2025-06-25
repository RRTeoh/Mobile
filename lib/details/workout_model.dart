import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Workout {
  final String id;
  String time;
  String label;
  String reps;
  String imagePath;

  Workout({
    required this.id,
    required this.time,
    required this.label,
    required this.reps,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() => {
        'time': time,
        'label': label,
        'reps': reps,
        'imagePath': imagePath,
      };

  factory Workout.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Workout(
      id: doc.id,
      time: data['time'],
      label: data['label'],
      reps: data['reps'],
      imagePath: data['imagePath'] ?? '', // fallback to empty string if missing
    );
  }
}
