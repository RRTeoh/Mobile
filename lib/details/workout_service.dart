import 'package:cloud_firestore/cloud_firestore.dart';
import 'workout_model.dart';

class WorkoutService {
  final CollectionReference _workoutsCollection =
      FirebaseFirestore.instance.collection('workouts');

  Stream<List<Workout>> streamWorkouts() {
    return _workoutsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Workout.fromDoc(doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    });
  }

  Future<void> updateWorkout(Workout workout) {
    return _workoutsCollection.doc(workout.id).update(workout.toMap());
  }

  Future<void> addWorkout(Workout workout) {
    return _workoutsCollection.add(workout.toMap());
  }

  Future<void> deleteWorkout(String id) async {
    await _workoutsCollection.doc(id).delete();
  }

  int calculateCaloriesBurned(String workoutName, int reps, int minutes) {
  // Example multipliers — you can customize these based on real MET values
  final baseRate = {
    'Push-ups': 8,
    'Sit-ups': 6,
    'Jumping Jacks': 7,
    'Plank': 5,
    'Squats': 6,
    'Lunges': 6,
    'Mountain Climbers': 7,
    'High Knees': 7,
    'Run': 12,
    'Swim': 10,
    'Rowing': 9,
    'Cycling': 8,
  };

  int rate = baseRate[workoutName] ?? 5;
  return ((rate * minutes) + (reps * 0.1)).toInt(); // Simple formula
}

  
}
