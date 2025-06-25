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
  
}
