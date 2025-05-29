import 'package:flutter/material.dart';
import 'package:asgm1/nutrition_widgets/calorie_summary_section.dart';
import 'package:asgm1/nutrition_widgets/nutrition_bottom_sheet.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});
  
  @override
  State<NutritionPage> createState() => NutritionPageState();
}

class NutritionPageState extends State<NutritionPage> {
  DateTime selectedDate = DateTime.now();
  final GlobalKey<NutritionBottomSheetState> _bottomSheetKey = GlobalKey();
  
  // Shared Nutrition Data Status
  final int _baseGoal = 2000;
  int _foodCalories = 0; // Get the actual data from the bottom sheet
  final int _exerciseCalories = 100;

  void _goToPreviousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _goToNextDay() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
    });
  }

  void resetToDefault() {
    setState(() {
      selectedDate = DateTime.now();
    });
    _bottomSheetKey.currentState?.collapse();
  }

  // Updating the callback method for food calories
  void _updateFoodCalories(int calories) {
    if (_foodCalories != calories) {
      setState(() {
        _foodCalories = calories;
      });
    }
  }

  // // Methods for updating the base target (if dynamic modifications are required)
  // void _updateBaseGoal(int goal) {
  //   setState(() {
  //     _baseGoal = goal;
  //   });
  // }

  // // Method of updating exercise calories (if dynamic modifications are required)
  // void _updateExerciseCalories(int calories) {
  //   setState(() {
  //     _exerciseCalories = calories;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Column(
            children: [
              CalorieSummarySection(
                selectedDate: selectedDate,
                onPreviousDay: _goToPreviousDay,
                onNextDay: _goToNextDay,
                baseGoal: _baseGoal,
                foodCalories: _foodCalories,
                exerciseCalories: _exerciseCalories,
              )
            ],
          ),
          NutritionBottomSheet(
            key: _bottomSheetKey,
            baseGoal: _baseGoal,
            exerciseCalories: _exerciseCalories,
            onFoodCaloriesUpdate: _updateFoodCalories,
          ),
        ],
      ),
    );
  }
}