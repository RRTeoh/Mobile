import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalorieService {
  static const int _baseGoal = 2000;
  static const int _defaultExercise = 100;
  
  // Get the remaining calories for the current day
  static Future<int> getRemainingCalories() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return _baseGoal;
      
      final today = DateTime.now();
      final dateString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      
      // Get food calories
      final foodCalories = await _getFoodCalories(user.uid, dateString);
      
      // Use default exercise value
      final exerciseCalories = _defaultExercise;
      
      // Calculate remaining calories: baseGoal - food + exercise
      final remainingCalories = _baseGoal - foodCalories + exerciseCalories;
      
      return remainingCalories;
    } catch (e) {
      print('Error getting remaining calories: $e');
      return _baseGoal;
    }
  }
  
  // Get food calories
  static Future<int> _getFoodCalories(String userId, String dateString) async {
    try {
      int totalCalories = 0;
      
      // Loop through all meal types
      for (final mealType in ['Breakfast', 'Lunch', 'Dinner', 'Snack']) {
        final mealRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('meals')
            .doc(dateString)
            .collection('mealTypes')
            .doc(mealType);
        
        final mealDoc = await mealRef.get();
        if (mealDoc.exists) {
          final mealData = mealDoc.data();
          if (mealData != null) {
            final foods = mealData['foods'] as List<dynamic>?;
            if (foods != null) {
              for (final food in foods) {
                final calories = food['calories'] as int? ?? 0;
                totalCalories += calories;
              }
            }
          }
        }
      }
      
      return totalCalories;
    } catch (e) {
      print('Error getting food calories: $e');
      return 0;
    }
  }
  
  // Get the base goal calories
  static int getBaseGoal() {
    return _baseGoal;
  }
} 